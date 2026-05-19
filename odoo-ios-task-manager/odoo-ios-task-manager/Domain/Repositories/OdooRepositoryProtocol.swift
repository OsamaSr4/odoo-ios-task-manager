import Foundation

protocol OdooRepositoryProtocol {
    func restoreSession(uid: Int, password: String)
    func login(username: String, password: String) async throws -> Int
    func fetchProjects() async throws -> [ProjectEntity]
    func fetchTasks(projectId: Int) async throws -> [TaskEntity]
    func fetchTaskStages() async throws -> [TaskStageEntity]
    func createTask(name: String, description: String, projectId: Int, deadline: String?) async throws
    func updateTaskStatus(taskId: Int, stageId: Int) async throws
    func updateUserName(name: String) async throws
}
