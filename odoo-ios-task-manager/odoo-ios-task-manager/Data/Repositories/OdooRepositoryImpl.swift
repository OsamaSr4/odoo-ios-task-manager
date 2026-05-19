import Foundation

final class OdooRepositoryImpl: OdooRepositoryProtocol {
    private let remoteDataSource: OdooRemoteDataSourceProtocol
    private var uid: Int?
    private var password: String?

    init(remoteDataSource: OdooRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func restoreSession(uid: Int, password: String) {
        self.uid = uid
        self.password = password
    }

    func login(username: String, password: String) async throws -> Int {
        let uid = try await remoteDataSource.login(username: username, password: password)
        self.uid = uid
        self.password = password
        return uid
    }

    func fetchProjects() async throws -> [ProjectEntity] {
        let projects = try await remoteDataSource.fetchProjects(
            uid: try currentUID(),
            password: try currentPassword()
        )

        return projects.map(map)
    }

    func fetchTasks(projectId: Int) async throws -> [TaskEntity] {
        guard projectId > 0 else {
            throw OdooError.validation("Project id must be greater than 0.")
        }

        let uid = try currentUID()
        let password = try currentPassword()

        do {
            let assignedTasks = try await remoteDataSource.fetchTasks(
                uid: uid,
                password: password,
                projectId: projectId,
                assignedOnly: true
            )
            if !assignedTasks.isEmpty {
                return assignedTasks.map(map)
            }
        } catch {
            let fallbackTasks = try await remoteDataSource.fetchTasks(
                uid: uid,
                password: password,
                projectId: projectId,
                assignedOnly: false
            )
            return fallbackTasks.map(map)
        }

        let fallbackTasks = try await remoteDataSource.fetchTasks(
            uid: uid,
            password: password,
            projectId: projectId,
            assignedOnly: false
        )
        return fallbackTasks.map(map)
    }

    func fetchTaskStages() async throws -> [TaskStageEntity] {
        let stages = try await remoteDataSource.fetchTaskStages(
            uid: try currentUID(),
            password: try currentPassword()
        )

        return stages.map(map)
    }

    func createTask(name: String, description: String, projectId: Int, stageId: Int?, deadline: String?) async throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw OdooError.validation("Task name is required.")
        }

        guard projectId > 0 else {
            throw OdooError.validation("Project id must be greater than 0.")
        }

        if let deadline, !deadline.isEmpty, !Self.isValidDeadline(deadline) {
            throw OdooError.validation("Deadline must use yyyy-MM-dd format.")
        }

        try await remoteDataSource.createTask(
            uid: try currentUID(),
            password: try currentPassword(),
            name: trimmedName,
            description: trimmedDescription,
            projectId: projectId,
            stageId: stageId,
            deadline: deadline
        )
    }

    func updateTaskStatus(taskId: Int, stageId: Int) async throws {
        guard taskId > 0, stageId > 0 else {
            throw OdooError.validation("Task id and stage id must be greater than 0.")
        }

        try await remoteDataSource.updateTaskStatus(
            uid: try currentUID(),
            password: try currentPassword(),
            taskId: taskId,
            stageId: stageId
        )
    }

    func updateUserName(name: String) async throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw OdooError.validation("User name is required.")
        }

        try await remoteDataSource.updateUserName(
            uid: try currentUID(),
            password: try currentPassword(),
            name: trimmedName
        )
    }

    private func currentUID() throws -> Int {
        guard let uid else {
            throw OdooError.missingSession
        }

        return uid
    }

    private func currentPassword() throws -> String {
        guard let password else {
            throw OdooError.missingSession
        }

        return password
    }

    private func map(_ dto: TaskDTO) -> TaskEntity {
        TaskEntity(
            id: dto.id,
            name: dto.name,
            stageId: dto.stageId,
            stageName: dto.stageName,
            deadline: dto.deadline
        )
    }

    private func map(_ dto: ProjectDTO) -> ProjectEntity {
        ProjectEntity(id: dto.id, name: dto.name)
    }

    private func map(_ dto: TaskStageDTO) -> TaskStageEntity {
        TaskStageEntity(id: dto.id, name: dto.name, sequence: dto.sequence)
    }

    private static func isValidDeadline(_ deadline: String) -> Bool {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: deadline) != nil
    }
}
