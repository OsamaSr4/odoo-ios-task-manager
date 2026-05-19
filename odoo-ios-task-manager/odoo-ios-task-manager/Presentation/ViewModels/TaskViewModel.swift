import Foundation
import Combine

@MainActor
final class TaskViewModel: ObservableObject {
    @Published private(set) var tasks: [TaskEntity] = []
    @Published private(set) var taskStatusOptions: [TaskStatusOption] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var username = "Guest User"
    @Published private(set) var selectedProject: ProjectEntity?

    private let fetchTasksUseCase: FetchTasksUseCase
    private let fetchTaskStagesUseCase: FetchTaskStagesUseCase
    private let createTaskUseCase: CreateTaskUseCase
    private let updateTaskStatusUseCase: UpdateTaskStatusUseCase
    private let updateUserNameUseCase: UpdateUserNameUseCase

    init(
        fetchTasksUseCase: FetchTasksUseCase,
        fetchTaskStagesUseCase: FetchTaskStagesUseCase,
        createTaskUseCase: CreateTaskUseCase,
        updateTaskStatusUseCase: UpdateTaskStatusUseCase,
        updateUserNameUseCase: UpdateUserNameUseCase
    ) {
        self.fetchTasksUseCase = fetchTasksUseCase
        self.fetchTaskStagesUseCase = fetchTaskStagesUseCase
        self.createTaskUseCase = createTaskUseCase
        self.updateTaskStatusUseCase = updateTaskStatusUseCase
        self.updateUserNameUseCase = updateUserNameUseCase
    }

    func setUsername(_ username: String) {
        self.username = username
    }

    func loadTasks(for project: ProjectEntity) async {
        await performLoading {
            self.selectedProject = project
            self.taskStatusOptions = try await makeStatusOptions()
            self.tasks = try await fetchTasksUseCase.execute(projectId: project.id)
        }
    }

    func createTask(name: String, description: String, deadline: String?) async {
        await performLoading {
            guard let selectedProject else {
                throw OdooError.validation("Please select a project first.")
            }

            try await createTaskUseCase.execute(
                name: name,
                description: description,
                projectId: selectedProject.id,
                deadline: deadline
            )
            self.tasks = try await fetchTasksUseCase.execute(projectId: selectedProject.id)
        }
    }

    func updateStatus(taskId: Int, stageId: Int) async {
        await performLoading {
            try await updateTaskStatusUseCase.execute(taskId: taskId, stageId: stageId)
            if let selectedProject {
                self.tasks = try await fetchTasksUseCase.execute(projectId: selectedProject.id)
            }
        }
    }

    func stageId(for status: TaskStatus) -> Int? {
        taskStatusOptions.first { $0.status == status }?.stageId
    }

    func updateUserName(name: String) async {
        await performLoading {
            try await updateUserNameUseCase.execute(name: name)
            self.username = name
        }
    }

    private func performLoading(_ operation: () async throws -> Void) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await operation()
        } catch let error as OdooError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func makeStatusOptions() async throws -> [TaskStatusOption] {
        let stages = try await fetchTaskStagesUseCase.execute()
            .sorted { lhs, rhs in
                if lhs.sequence != rhs.sequence {
                    return (lhs.sequence ?? Int.max) < (rhs.sequence ?? Int.max)
                }

                return lhs.id < rhs.id
            }

        let pending = bestStage(for: .pending, in: stages)
        let inProgress = bestStage(for: .inProgress, in: stages)
        let completed = bestStage(for: .completed, in: stages)

        return [
            pending.map { TaskStatusOption(status: .pending, stageId: $0.id, stageName: $0.name) },
            inProgress.map { TaskStatusOption(status: .inProgress, stageId: $0.id, stageName: $0.name) },
            completed.map { TaskStatusOption(status: .completed, stageId: $0.id, stageName: $0.name) }
        ].compactMap { $0 }
    }

    private func bestStage(for status: TaskStatus, in stages: [TaskStageEntity]) -> TaskStageEntity? {
        stages
            .filter { !$0.name.localizedCaseInsensitiveContains("cancel") }
            .map { ($0, stageScore($0.name, for: status)) }
            .filter { $0.1 > 0 }
            .sorted { lhs, rhs in
                if lhs.1 != rhs.1 {
                    return lhs.1 > rhs.1
                }

                if lhs.0.sequence != rhs.0.sequence {
                    return (lhs.0.sequence ?? Int.max) < (rhs.0.sequence ?? Int.max)
                }

                return lhs.0.id < rhs.0.id
            }
            .first?
            .0
    }

    private func stageScore(_ name: String, for status: TaskStatus) -> Int {
        let lowercasedName = name.lowercased()

        switch status {
        case .pending:
            if lowercasedName == "pending" { return 110 }
            if lowercasedName == "user" { return 100 }
            if lowercasedName.contains("inbox") { return 90 }
            if lowercasedName.contains("new") { return 80 }
            if lowercasedName.contains("todo") || lowercasedName.contains("to do") { return 70 }
            if lowercasedName.contains("done") ||
                lowercasedName.contains("completed") ||
                lowercasedName.contains("progress") ||
                lowercasedName.contains("task") ||
                lowercasedName.contains("today") ||
                lowercasedName.contains("week") ||
                lowercasedName.contains("month") ||
                lowercasedName.contains("later") {
                return 0
            }
            return 1
        case .inProgress:
            if lowercasedName == "in progress" { return 110 }
            if lowercasedName == "tasks" { return 100 }
            if lowercasedName.contains("progress") { return 90 }
            if lowercasedName.contains("today") { return 80 }
            if lowercasedName.contains("week") { return 70 }
            if lowercasedName.contains("task") { return 60 }
            return 0
        case .completed:
            if lowercasedName == "done" { return 100 }
            if lowercasedName.contains("completed") { return 90 }
            if lowercasedName.contains("done") { return 80 }
            return 0
        }
    }
}
