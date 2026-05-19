import Foundation

protocol OdooRepositoryProtocol {
    func login(username: String, password: String) async throws -> Int
    func fetchTasks() async throws -> [TaskEntity]
    func fetchTaskStages() async throws -> [TaskStageEntity]
    func createTask(name: String, description: String, projectId: Int, deadline: String?) async throws
    func updateTaskStatus(taskId: Int, stageId: Int) async throws
    func updateUserName(name: String) async throws
}
