import Foundation

struct FetchTaskStagesUseCase {
    let repository: OdooRepositoryProtocol

    func execute() async throws -> [TaskStageEntity] {
        try await repository.fetchTaskStages()
    }
}
