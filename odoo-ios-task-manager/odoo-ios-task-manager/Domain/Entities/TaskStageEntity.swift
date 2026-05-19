import Foundation

struct TaskStageEntity: Identifiable, Equatable {
    let id: Int
    let name: String
    let sequence: Int?
}
