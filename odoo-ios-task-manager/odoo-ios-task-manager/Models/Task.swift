import Foundation
import SwiftUI

enum TaskStatus: String, CaseIterable {
    case pending = "pending"
    case inProgress = "in_progress"
    case completed = "completed"
    
    var displayName: String {
        switch self {
        case .pending:
            return "Pending"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        }
    }
    
    var color: (background: Color, text: Color) {
        switch self {
        case .pending:
            return (Color.orange.opacity(0.1), Color.orange)
        case .inProgress:
            return (Color.blue.opacity(0.1), Color.blue)
        case .completed:
            return (Color.green.opacity(0.1), Color.green)
        }
    }

    init(stageId: Int?, stageName: String?) {
        if stageName?.localizedCaseInsensitiveContains("done") == true ||
            stageName?.localizedCaseInsensitiveContains("completed") == true {
            self = .completed
        } else if stageName?.localizedCaseInsensitiveContains("progress") == true ||
                    stageName?.localizedCaseInsensitiveContains("today") == true ||
                    stageName?.localizedCaseInsensitiveContains("week") == true ||
                    stageName?.localizedCaseInsensitiveContains("month") == true ||
                    stageName?.localizedCaseInsensitiveContains("later") == true ||
                    stageName?.localizedCaseInsensitiveContains("task") == true {
            self = .inProgress
        } else {
            self = .pending
        }
    }
}

struct TaskStatusOption: Identifiable, Equatable {
    let status: TaskStatus
    let stageId: Int
    let stageName: String

    var id: TaskStatus { status }
}

extension TaskEntity {
    var progressStatus: TaskStatus {
        TaskStatus(stageId: stageId, stageName: stageName)
    }
}
