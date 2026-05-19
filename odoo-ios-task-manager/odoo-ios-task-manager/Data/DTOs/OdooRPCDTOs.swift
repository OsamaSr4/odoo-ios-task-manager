import Foundation

struct OdooRPCRequest: Encodable {
    let jsonrpc = "2.0"
    let method = "call"
    let params: OdooRPCParams
}

struct OdooRPCParams: Encodable {
    let service: String
    let method: String
    let args: [JSONValue]
}

struct OdooRPCResponse: Decodable {
    let result: JSONValue?
    let error: OdooRPCError?
}

struct OdooRPCError: Decodable {
    let code: Int?
    let message: String?
    let data: OdooRPCErrorData?
}

struct OdooRPCErrorData: Decodable {
    let name: String?
    let message: String?
    let debug: String?
}
