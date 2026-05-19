import Foundation

struct LoginUseCase {
    let repository: OdooRepositoryProtocol

    func execute(username: String, password: String) async throws -> Int {
        try await repository.login(username: username, password: password)
    }
}
