import SwiftUI

struct TaskCell: View {
    let task: TaskEntity
    let onTap: (() -> Void)?
    
    init(task: TaskEntity, onTap: (() -> Void)? = nil) {
        self.task = task
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            let status = task.progressStatus

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    AppText(task.name, variant: .medium, size: 16)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    TagView(
                        task.stageName ?? status.displayName,
                        backgroundColor: status.color.background,
                        textColor: status.color.text
                    )
                }

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
        guard let deadline = task.deadline, !deadline.isEmpty else {
            return "No deadline"
        }

        let inputFormatter = DateFormatter()
        inputFormatter.calendar = Calendar(identifier: .gregorian)
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        for format in ["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd"] {
            inputFormatter.dateFormat = format
            if let date = inputFormatter.date(from: deadline) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MMM d, yyyy"
                return outputFormatter.string(from: date)
            }
        }

        return deadline
    }
}

#Preview {
    VStack(spacing: 12) {
        TaskCell(task: TaskEntity(id: 1, name: "Complete project documentation", stageId: 1, stageName: "New", deadline: "2026-03-15"))
        TaskCell(task: TaskEntity(id: 2, name: "Review pull requests", stageId: 2, stageName: "In Progress", deadline: nil))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
