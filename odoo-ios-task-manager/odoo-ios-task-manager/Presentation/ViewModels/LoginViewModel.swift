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

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
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
        } catch let error as OdooError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
