import SwiftUI

struct AppNavigationView: View {
    @StateObject private var loginViewModel: LoginViewModel
    @StateObject private var taskViewModel: TaskViewModel

    init(viewModels: AppViewModels = AppDependencyContainer.makeAppViewModels()) {
        self._loginViewModel = StateObject(wrappedValue: viewModels.loginViewModel)
        self._taskViewModel = StateObject(wrappedValue: viewModels.taskViewModel)
    }

    var body: some View {
        NavigationStack {
            rootView
        }
    }

    @ViewBuilder
    private var rootView: some View {
        if loginViewModel.isLoggedIn {
            destination(for: .taskList)
        } else {
            LoginScreenView(viewModel: loginViewModel)
            .overlay(alignment: .bottom) {
                messageView
            }
            .onChange(of: loginViewModel.isLoggedIn) { _, isLoggedIn in
                guard isLoggedIn else { return }
                taskViewModel.setUsername(loginViewModel.username)
                _Concurrency.Task {
                    await taskViewModel.loadTasks()
                }
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .taskList:
            TaskListScreen(viewModel: taskViewModel)
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
