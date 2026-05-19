import SwiftUI

struct AppNavigationView: View {
    @StateObject private var loginViewModel: LoginViewModel
    @StateObject private var projectListViewModel: ProjectListViewModel
    @StateObject private var taskViewModel: TaskViewModel
    @State private var path: [AppRoute] = []
    @State private var showUpdateProfileSheet = false

    init(viewModels: AppViewModels = AppDependencyContainer.makeAppViewModels()) {
        self._loginViewModel = StateObject(wrappedValue: viewModels.loginViewModel)
        self._projectListViewModel = StateObject(wrappedValue: viewModels.projectListViewModel)
        self._taskViewModel = StateObject(wrappedValue: viewModels.taskViewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            rootView
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
        .onAppear {
            if loginViewModel.isLoggedIn {
                taskViewModel.setUsername(loginViewModel.username)
            }
        }
        .sheet(isPresented: $showUpdateProfileSheet) {
            UpdateProfileSheet(isPresented: $showUpdateProfileSheet, username: taskViewModel.username) { updatedUsername in
                _Concurrency.Task {
                    await taskViewModel.updateUserName(name: updatedUsername)
                    taskViewModel.setUsername(updatedUsername)
                }
            }
        }
    }

    @ViewBuilder
    private var rootView: some View {
        if loginViewModel.isLoggedIn {
            ProjectListScreen(
                viewModel: projectListViewModel,
                username: taskViewModel.username,
                onSelectProject: { project in
                    path.append(.taskList(project))
                },
                onUpdateProfile: {
                    showUpdateProfileSheet = true
                }
            )
        } else {
            LoginScreenView(viewModel: loginViewModel)
            .overlay(alignment: .bottom) {
                messageView
            }
            .onChange(of: loginViewModel.isLoggedIn) { _, isLoggedIn in
                guard isLoggedIn else { return }
                taskViewModel.setUsername(loginViewModel.username)
                _Concurrency.Task {
                    await projectListViewModel.loadProjects()
                }
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .taskList(let project):
            TaskListScreen(
                viewModel: taskViewModel,
                project: project,
                onBackPressed: {
                    path.removeLast()
                }
            )
        }
    }

    @ViewBuilder
    private var messageView: some View {
        if let errorMessage = loginViewModel.errorMessage {
            AppText(errorMessage, variant: .regular, color: .red)
                .padding()
        }
    }
}

#Preview {
    AppNavigationView()
}
