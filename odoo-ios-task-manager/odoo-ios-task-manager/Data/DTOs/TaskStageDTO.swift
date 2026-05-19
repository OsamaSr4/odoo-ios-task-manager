import Foundation

struct TaskStageDTO {
    let id: Int
    let name: String
    let sequence: Int?

    init?(json: JSONValue) {
        guard case .object(let object) = json,
              let id = object["id"]?.intValue,
              let name = object["name"]?.stringValue else {
            return nil
        }

        self.id = id
        self.name = name
        self.sequence = object["sequence"]?.intValue
    }
}
