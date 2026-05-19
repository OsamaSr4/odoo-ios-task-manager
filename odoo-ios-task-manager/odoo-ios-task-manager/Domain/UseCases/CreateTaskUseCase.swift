import Foundation

struct CreateTaskUseCase {
    let repository: OdooRepositoryProtocol

    func execute(name: String, description: String, projectId: Int, stageId: Int?, deadline: String?) async throws {
        try await repository.createTask(
            name: name,
            description: description,
            projectId: projectId,
            stageId: stageId,
            deadline: deadline
        )
    }
}
