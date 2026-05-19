import Foundation
import Security

protocol OdooSessionStoreProtocol {
    func save(_ session: OdooSession)
    func load() -> OdooSession?
    func clear()
}

final class OdooSessionStore: OdooSessionStoreProtocol {
    private enum Keys {
        static let uid = "odoo.session.uid"
        static let username = "odoo.session.username"
        static let passwordAccount = "odoo.session.password"
        static let passwordService = "odoo-ios-task-manager"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save(_ session: OdooSession) {
        defaults.set(session.uid, forKey: Keys.uid)
        defaults.set(session.username, forKey: Keys.username)
        savePassword(session.password)
    }

    func load() -> OdooSession? {
        let uid = defaults.integer(forKey: Keys.uid)
        guard uid > 0,
              let username = defaults.string(forKey: Keys.username),
              let password = loadPassword() else {
            return nil
        }

        return OdooSession(uid: uid, username: username, password: password)
    }

    func clear() {
        defaults.removeObject(forKey: Keys.uid)
        defaults.removeObject(forKey: Keys.username)
        deletePassword()
    }

    private func savePassword(_ password: String) {
        deletePassword()

        guard let data = password.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Keys.passwordService,
            kSecAttrAccount as String: Keys.passwordAccount,
            kSecValueData as String: data
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    private func loadPassword() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Keys.passwordService,
            kSecAttrAccount as String: Keys.passwordAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    private func deletePassword() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Keys.passwordService,
            kSecAttrAccount as String: Keys.passwordAccount
        ]

        SecItemDelete(query as CFDictionary)
    }
}
