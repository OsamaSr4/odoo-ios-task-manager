import SwiftUI

struct AppNavigationView: View {
    @StateObject private var session = AppSession()

    var body: some View {
        NavigationStack {
            rootView
        }
    }

    @ViewBuilder
    private var rootView: some View {
        if session.isLoggedIn {
            destination(for: .taskList)
        } else {
            LoginScreenView { email, password in
                session.login(email: email, password: password)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .taskList:
            TaskListScreen()
        }
    }
}

#Preview {
    AppNavigationView()
}
