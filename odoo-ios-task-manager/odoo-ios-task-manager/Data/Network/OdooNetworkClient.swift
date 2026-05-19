import Foundation

final class OdooNetworkClient {
    private let endpoint: URL
    private let session: URLSession
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let isLoggingEnabled: Bool

    init(
        endpoint: String = OdooConfig.jsonRPCEndpoint,
        session: URLSession = OdooNetworkClient.makeSession(),
        isLoggingEnabled: Bool = true
    ) throws {
        guard let url = URL(string: endpoint) else {
            throw OdooError.invalidURL
        }

        self.endpoint = url
        self.session = session
        self.isLoggingEnabled = isLoggingEnabled
    }

    func call(service: String, method: String, args: [JSONValue]) async throws -> JSONValue {
        let payload = OdooRPCRequest(
            params: OdooRPCParams(service: service, method: method, args: args)
        )

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(payload)
        request.httpShouldHandleCookies = true
        logRequest(service: service, method: method, body: request.httpBody)

        do {
            let (data, response) = try await session.data(for: request)
            logResponse(response, data: data)

            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                log("HTTP error status: \(httpResponse.statusCode)")
                throw OdooError.serverError("Odoo returned HTTP \(httpResponse.statusCode).")
            }

            let rpcResponse: OdooRPCResponse

            do {
                rpcResponse = try decoder.decode(OdooRPCResponse.self, from: data)
            } catch {
                log("Decoding error: \(error.localizedDescription)")
                logRawData(data)
                throw OdooError.decodingError
            }

            if let error = rpcResponse.error {
                logOdooError(error)
                throw map(error)
            }

            guard let result = rpcResponse.result else {
                throw OdooError.decodingError
            }

            return result
        } catch let error as OdooError {
            log("Mapped error: \(error.localizedDescription)")
            throw error
        } catch is DecodingError {
            log("Decoding error thrown before mapping.")
            throw OdooError.decodingError
        } catch {
            log("Network error: \(error.localizedDescription)")
            throw OdooError.serverError(error.localizedDescription)
        }
    }

    private func map(_ error: OdooRPCError) -> OdooError {
        let message = error.data?.message ?? error.message ?? "Odoo server error."

        if message.localizedCaseInsensitiveContains("login") ||
            message.localizedCaseInsensitiveContains("password") ||
            message.localizedCaseInsensitiveContains("access denied") {
            return .invalidCredentials
        }

        return .serverError(message)
    }

    private static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.httpCookieAcceptPolicy = .always
        configuration.httpShouldSetCookies = true
        return URLSession(configuration: configuration)
    }

    private func logRequest(service: String, method: String, body: Data?) {
        log("Request: service=\(service), method=\(method), endpoint=\(endpoint.absoluteString)")
        guard let body else { return }
        logRawData(body, prefix: "Request body")
    }

    private func logResponse(_ response: URLResponse, data: Data) {
        if let httpResponse = response as? HTTPURLResponse {
            log("Response status: \(httpResponse.statusCode)")
        }
        logRawData(data, prefix: "Response body")
    }

    private func logOdooError(_ error: OdooRPCError) {
        log("Odoo error code: \(error.code.map(String.init) ?? "nil")")
        log("Odoo error message: \(error.message ?? "nil")")
        log("Odoo error data name: \(error.data?.name ?? "nil")")
        log("Odoo error data message: \(error.data?.message ?? "nil")")

        if let debug = error.data?.debug, !debug.isEmpty {
            log("Odoo error debug: \(debug)")
        }
    }

    private func logRawData(_ data: Data, prefix: String = "Raw data") {
        guard let text = String(data: data, encoding: .utf8) else {
            log("\(prefix): <non-UTF8 data, \(data.count) bytes>")
            return
        }

        log("\(prefix): \(text)")
    }

    private func log(_ message: String) {
        guard isLoggingEnabled else { return }
        print("[OdooNetworkClient] \(message)")
    }
}
