import Foundation

protocol OdooRemoteDataSourceProtocol {
    func login(username: String, password: String) async throws -> Int
    func fetchProjects(uid: Int, password: String) async throws -> [ProjectDTO]
    func fetchTasks(uid: Int, password: String, projectId: Int, assignedOnly: Bool) async throws -> [TaskDTO]
    func fetchTaskStages(uid: Int, password: String) async throws -> [TaskStageDTO]
    func createTask(uid: Int, password: String, name: String, description: String, projectId: Int, stageId: Int?, deadline: String?) async throws
    func updateTaskStatus(uid: Int, password: String, taskId: Int, stageId: Int) async throws
    func updateUserName(uid: Int, password: String, name: String) async throws
}

final class OdooRemoteDataSource: OdooRemoteDataSourceProtocol {
    private let client: OdooNetworkClient

    init(client: OdooNetworkClient) {
        self.client = client
    }

    func login(username: String, password: String) async throws -> Int {
        let result = try await client.call(
            service: "common",
            method: "authenticate",
            args: [
                .string(OdooConfig.database),
                .string(username),
                .string(password),
                .object([:])
            ]
        )
        
        if result.boolValue == false {
            throw OdooError.invalidCredentials
        }

        guard let uid = result.intValue else {
            throw OdooError.missingUID
        }

        return uid
    }

    func fetchProjects(uid: Int, password: String) async throws -> [ProjectDTO] {
        let result = try await client.call(
            service: "object",
            method: "execute_kw",
            args: [
                .string(OdooConfig.database),
                .int(uid),
                .string(password),
                .string("project.project"),
                .string("search_read"),
                .array([.array([])]),
                .object([
                    "fields": .array([
                        .string("id"),
                        .string("name")
                    ]),
                    "limit": .int(50)
                ])
            ]
        )

        guard let projectValues = result.arrayValue else {
            throw OdooError.decodingError
        }

        return projectValues.compactMap(ProjectDTO.init(json:))
    }

    func fetchTasks(uid: Int, password: String, projectId: Int, assignedOnly: Bool) async throws -> [TaskDTO] {
        let domain: JSONValue = assignedOnly ? .array([
            .array([
                .string("project_id"),
                .string("="),
                .int(projectId)
            ]),
            .array([
                .string("user_ids"),
                .string("in"),
                .array([.int(uid)])
            ])
        ]) : .array([
            .array([
                .string("project_id"),
                .string("="),
                .int(projectId)
            ])
        ])

        let result = try await client.call(
            service: "object",
            method: "execute_kw",
            args: [
                .string(OdooConfig.database),
                .int(uid),
                .string(password),
                .string("project.task"),
                .string("search_read"),
                .array([domain]),
                .object([
                    "fields": .array([
                        .string("id"),
                        .string("name"),
                        .string("stage_id"),
                        .string("date_deadline")
                    ]),
                    "limit": .int(20)
                ])
            ]
        )

        guard let taskValues = result.arrayValue else {
            throw OdooError.decodingError
        }

        return taskValues.compactMap(TaskDTO.init(json:))
    }

    func fetchTaskStages(uid: Int, password: String) async throws -> [TaskStageDTO] {
        let result = try await client.call(
            service: "object",
            method: "execute_kw",
            args: [
                .string(OdooConfig.database),
                .int(uid),
                .string(password),
                .string("project.task.type"),
                .string("search_read"),
                .array([.array([])]),
                .object([
                    "fields": .array([
                        .string("id"),
                        .string("name"),
                        .string("sequence")
                    ]),
                    "limit": .int(50)
                ])
            ]
        )

        guard let stageValues = result.arrayValue else {
            throw OdooError.decodingError
        }

        return stageValues.compactMap(TaskStageDTO.init(json:))
    }

    func createTask(uid: Int, password: String, name: String, description: String, projectId: Int, stageId: Int?, deadline: String?) async throws {
        var values: [String: JSONValue] = [
            "name": .string(name),
            "project_id": .int(projectId),
            "user_ids": .array([
                .array([.int(6), .int(0), .array([.int(uid)])])
            ])
        ]

        if let stageId {
            values["stage_id"] = .int(stageId)
        }

        if !description.isEmpty {
            values["description"] = .string(description)
        }

        if let deadline, !deadline.isEmpty {
            values["date_deadline"] = .string(deadline)
        }

        _ = try await client.call(
            service: "object",
            method: "execute_kw",
            args: [
                .string(OdooConfig.database),
                .int(uid),
                .string(password),
                .string("project.task"),
                .string("create"),
                .array([.object(values)])
            ]
        )
    }

    func updateTaskStatus(uid: Int, password: String, taskId: Int, stageId: Int) async throws {
        _ = try await client.call(
            service: "object",
            method: "execute_kw",
            args: [
                .string(OdooConfig.database),
                .int(uid),
                .string(password),
                .string("project.task"),
                .string("write"),
                .array([
                    .array([.int(taskId)]),
                    .object(["stage_id": .int(stageId)])
                ])
            ]
        )
    }

    func updateUserName(uid: Int, password: String, name: String) async throws {
        _ = try await client.call(
            service: "object",
            method: "execute_kw",
            args: [
                .string(OdooConfig.database),
                .int(uid),
                .string(password),
                .string("res.users"),
                .string("write"),
                .array([
                    .array([.int(uid)]),
                    .object(["name": .string(name)])
                ])
            ]
        )
    }
}
