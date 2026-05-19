import Foundation

struct UpdateTaskStatusUseCase {
    let repository: OdooRepositoryProtocol

    func execute(taskId: Int, stageId: Int) async throws {
        try await repository.updateTaskStatus(taskId: taskId, stageId: stageId)
    }
}
