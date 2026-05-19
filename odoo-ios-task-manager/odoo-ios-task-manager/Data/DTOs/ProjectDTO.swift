import Foundation

struct ProjectDTO {
    let id: Int
    let name: String

    init?(json: JSONValue) {
        guard case .object(let object) = json,
              let id = object["id"]?.intValue,
              let name = object["name"]?.stringValue else {
            return nil
        }

        self.id = id
        self.name = name
    }
}
