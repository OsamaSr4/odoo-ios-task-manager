import Foundation

struct RestoreSessionUseCase {
    let repository: OdooRepositoryProtocol

    func execute(uid: Int, password: String) {
        repository.restoreSession(uid: uid, password: password)
    }
}
