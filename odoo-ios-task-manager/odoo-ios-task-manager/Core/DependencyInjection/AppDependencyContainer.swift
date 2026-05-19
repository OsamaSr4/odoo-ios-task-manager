import Foundation

struct AppViewModels {
    let loginViewModel: LoginViewModel
    let projectListViewModel: ProjectListViewModel
    let taskViewModel: TaskViewModel
}

enum AppDependencyContainer {
    static func makeAppViewModels() -> AppViewModels {
        do {
            let client = try OdooNetworkClient()
            let dataSource = OdooRemoteDataSource(client: client)
            let repository = OdooRepositoryImpl(remoteDataSource: dataSource)

            return makeViewModels(repository: repository, sessionStore: OdooSessionStore())
        } catch {
            let repository = OdooRepositoryImpl(remoteDataSource: FailingOdooRemoteDataSource(error: error))
            return makeViewModels(repository: repository, sessionStore: OdooSessionStore())
        }
    }

    static func makeTaskViewModel() -> TaskViewModel {
        makeAppViewModels().taskViewModel
    }

    private static func makeViewModels(
        repository: OdooRepositoryProtocol,
        sessionStore: OdooSessionStoreProtocol
    ) -> AppViewModels {
        AppViewModels(
            loginViewModel: LoginViewModel(
                loginUseCase: LoginUseCase(repository: repository),
                restoreSessionUseCase: RestoreSessionUseCase(repository: repository),
                sessionStore: sessionStore
            ),
            projectListViewModel: ProjectListViewModel(
                fetchProjectsUseCase: FetchProjectsUseCase(repository: repository)
            ),
            taskViewModel: TaskViewModel(
                fetchTasksUseCase: FetchTasksUseCase(repository: repository),
                fetchTaskStagesUseCase: FetchTaskStagesUseCase(repository: repository),
                createTaskUseCase: CreateTaskUseCase(repository: repository),
                updateTaskStatusUseCase: UpdateTaskStatusUseCase(repository: repository),
                updateUserNameUseCase: UpdateUserNameUseCase(repository: repository)
            )
        )
    }
}

private final class FailingOdooRemoteDataSource: OdooRemoteDataSourceProtocol {
    private let error: Error

    init(error: Error) {
        self.error = error
    }

    func login(username: String, password: String) async throws -> Int { throw error }
    func fetchProjects(uid: Int, password: String) async throws -> [ProjectDTO] { throw error }
    func fetchTasks(uid: Int, password: String, projectId: Int, assignedOnly: Bool) async throws -> [TaskDTO] { throw error }
    func fetchTaskStages(uid: Int, password: String) async throws -> [TaskStageDTO] { throw error }
    func createTask(uid: Int, password: String, name: String, description: String, projectId: Int, stageId: Int?, deadline: String?) async throws { throw error }
    func updateTaskStatus(uid: Int, password: String, taskId: Int, stageId: Int) async throws { throw error }
    func updateUserName(uid: Int, password: String, name: String) async throws { throw error }
}
