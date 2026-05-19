import SwiftUI

struct ProjectListScreen: View {
    @ObservedObject var viewModel: ProjectListViewModel
    let username: String
    let onSelectProject: (ProjectEntity) -> Void
    let onUpdateProfile: () -> Void
    let onLogout: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            AppBar(title: "Projects") {
                AvatarView.small(name: username) {
                    onUpdateProfile()
                }
            } rightContent: {
                Button(action: onLogout) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }

            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        AppText("Welcome", variant: .bold, size: 24)
                            .foregroundColor(.primary)

                        AppText(username, variant: .medium, size: 18)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.projects) { project in
                            Button(action: {
                                onSelectProject(project)
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "folder.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.blue)

                                    AppText(project.name, variant: .medium, size: 16)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)

                    if viewModel.projects.isEmpty && !viewModel.isLoading {
                        AppText("No projects found", variant: .regular)
                            .foregroundColor(.secondary)
                            .padding(.top, 24)
                    }
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))

            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }

            if let errorMessage = viewModel.errorMessage {
                AppText(errorMessage, variant: .regular, color: .red)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
        }
        .navigationBarHidden(true)
        .task {
            if viewModel.projects.isEmpty {
                await viewModel.loadProjects()
            }
        }
    }
}

#Preview {
    ProjectListScreen(
        viewModel: ProjectListViewModel(fetchProjectsUseCase: FetchProjectsUseCase(repository: OdooRepositoryImpl(remoteDataSource: FailingPreviewOdooRemoteDataSource()))),
        username: "Guest User",
        onSelectProject: { _ in },
        onUpdateProfile: {},
        onLogout: {}
    )
}

private final class FailingPreviewOdooRemoteDataSource: OdooRemoteDataSourceProtocol {
    func login(username: String, password: String) async throws -> Int { throw OdooError.unknown }
    func fetchProjects(uid: Int, password: String) async throws -> [ProjectDTO] { [] }
    func fetchTasks(uid: Int, password: String, projectId: Int, assignedOnly: Bool) async throws -> [TaskDTO] { [] }
    func fetchTaskStages(uid: Int, password: String) async throws -> [TaskStageDTO] { [] }
    func createTask(uid: Int, password: String, name: String, description: String, projectId: Int, deadline: String?) async throws {}
    func updateTaskStatus(uid: Int, password: String, taskId: Int, stageId: Int) async throws {}
    func updateUserName(uid: Int, password: String, name: String) async throws {}
}
