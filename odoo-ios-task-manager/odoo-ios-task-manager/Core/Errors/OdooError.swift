import Foundation

enum OdooError: LocalizedError {
    case invalidURL
    case invalidCredentials
    case serverError(String)
    case decodingError
    case missingUID
    case missingSession
    case validation(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The Odoo URL is invalid."
        case .invalidCredentials:
            return "Invalid Odoo username or password."
        case .serverError(let message):
            return message
        case .decodingError:
            return "Unable to read the Odoo response."
        case .missingUID:
            return "Odoo did not return a user id."
        case .missingSession:
            return "Please log in before continuing."
        case .validation(let message):
            return message
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
