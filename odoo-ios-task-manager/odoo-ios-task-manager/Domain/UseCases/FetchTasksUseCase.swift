import Foundation

struct FetchTasksUseCase {
    let repository: OdooRepositoryProtocol

    func execute() async throws -> [TaskEntity] {
        try await repository.fetchTasks()
    }
}
