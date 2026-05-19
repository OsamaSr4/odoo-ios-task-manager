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

struct Task: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let status: TaskStatus
    let dueDate: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        status: TaskStatus = .pending,
        dueDate: Date
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.dueDate = dueDate
    }
}

extension Task {
    static let sampleTasks: [Task] = [
        Task(
            title: "Complete project documentation",
            description: "Write comprehensive documentation for the new feature implementation",
            status: .pending,
            dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
        ),
        Task(
            title: "Review pull requests",
            description: "Review and approve pending pull requests from the team",
            status: .inProgress,
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        ),
        Task(
            title: "Update dependencies",
            description: "Update all project dependencies to their latest stable versions",
            status: .completed,
            dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        )
    ]
}
