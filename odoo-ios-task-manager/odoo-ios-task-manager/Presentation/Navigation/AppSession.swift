import Foundation
import Combine

@MainActor
final class AppSession: ObservableObject {
    @Published private(set) var isLoggedIn = false

    func login(email: String, password: String) {
        isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
    }
}
