import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var isLoggedIn = false
    @Published private(set) var uid: Int?
    @Published private(set) var username = OdooConfig.defaultUsername

    private let loginUseCase: LoginUseCase
    private let restoreSessionUseCase: RestoreSessionUseCase
    private let sessionStore: OdooSessionStoreProtocol

    init(
        loginUseCase: LoginUseCase,
        restoreSessionUseCase: RestoreSessionUseCase,
        sessionStore: OdooSessionStoreProtocol
    ) {
        self.loginUseCase = loginUseCase
        self.restoreSessionUseCase = restoreSessionUseCase
        self.sessionStore = sessionStore
        restoreSavedSession()
    }

    func login(username: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let uid = try await loginUseCase.execute(username: username, password: password)
            self.uid = uid
            self.username = username
            self.isLoggedIn = true
            sessionStore.save(OdooSession(uid: uid, username: username, password: password))
        } catch let error as OdooError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        sessionStore.clear()
        uid = nil
        username = OdooConfig.defaultUsername
        isLoggedIn = false
    }

    private func restoreSavedSession() {
        guard let session = sessionStore.load() else { return }

        restoreSessionUseCase.execute(uid: session.uid, password: session.password)
        uid = session.uid
        username = session.username
        isLoggedIn = true
    }
}
