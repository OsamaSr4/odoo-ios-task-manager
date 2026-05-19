import Foundation

struct UpdateUserNameUseCase {
    let repository: OdooRepositoryProtocol

    func execute(name: String) async throws {
        try await repository.updateUserName(name: name)
    }
}
