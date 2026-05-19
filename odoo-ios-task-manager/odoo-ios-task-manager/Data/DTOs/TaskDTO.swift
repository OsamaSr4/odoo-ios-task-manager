import Foundation

struct TaskDTO {
    let id: Int
    let name: String
    let stageId: Int?
    let stageName: String?
    let deadline: String?

    init?(json: JSONValue) {
        guard case .object(let object) = json,
              let id = object["id"]?.intValue,
              let name = object["name"]?.stringValue else {
            return nil
        }

        self.id = id
        self.name = name
        self.deadline = object["date_deadline"]?.stringValue

        if let stage = object["stage_id"]?.arrayValue {
            self.stageId = stage.first?.intValue
            self.stageName = stage.dropFirst().first?.stringValue
        } else {
            self.stageId = nil
            self.stageName = nil
        }
    }
}
