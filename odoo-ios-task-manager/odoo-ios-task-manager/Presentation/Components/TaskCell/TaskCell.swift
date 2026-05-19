import SwiftUI

struct TaskCell: View {
    let task: Task
    let onTap: (() -> Void)?
    
    init(task: Task, onTap: (() -> Void)? = nil) {
        self.task = task
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // Title row with status tag
                HStack {
                    AppText(task.title, variant: .medium, size: 16)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    TagView(
                        task.status.displayName,
                        backgroundColor: task.status.color.background,
                        textColor: task.status.color.text
                    )
                }
                
                // Description
                AppText(task.description, variant: .regular, size: 14)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                // Due date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                    
                    AppText("due : \(formattedDueDate)", variant: .regular, size: 12)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, d yyyy"
        return formatter.string(from: task.dueDate)
    }
}

#Preview {
    VStack(spacing: 12) {
        TaskCell(task: Task.sampleTasks[0])
        TaskCell(task: Task.sampleTasks[1])
        TaskCell(task: Task.sampleTasks[2])
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
