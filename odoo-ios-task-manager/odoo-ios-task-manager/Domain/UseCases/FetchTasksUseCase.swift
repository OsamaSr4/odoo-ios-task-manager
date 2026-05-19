import Foundation

struct FetchTasksUseCase {
    let repository: OdooRepositoryProtocol

    func execute(projectId: Int) async throws -> [TaskEntity] {
        try await repository.fetchTasks(projectId: projectId)
    }
}
