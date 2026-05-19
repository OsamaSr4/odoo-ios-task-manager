import Foundation

struct FetchProjectsUseCase {
    let repository: OdooRepositoryProtocol

    func execute() async throws -> [ProjectEntity] {
        try await repository.fetchProjects()
    }
}
