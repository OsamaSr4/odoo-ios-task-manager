import Foundation

struct TaskEntity: Identifiable, Equatable {
    let id: Int
    let name: String
    let stageId: Int?
    let stageName: String?
    let deadline: String?
}
