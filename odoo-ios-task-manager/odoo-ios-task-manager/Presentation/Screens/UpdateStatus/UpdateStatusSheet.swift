import SwiftUI

struct UpdateStatusSheet: View {
    @Binding var isPresented: Bool
    let task: TaskEntity
    let statusOptions: [TaskStatusOption]
    let onUpdateStatus: (TaskStatusOption) -> Void

    init(
        isPresented: Binding<Bool>,
        task: TaskEntity,
        statusOptions: [TaskStatusOption],
        onUpdateStatus: @escaping (TaskStatusOption) -> Void
    ) {
        self._isPresented = isPresented
        self.task = task
        self.statusOptions = statusOptions
        self.onUpdateStatus = onUpdateStatus
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        AppText("Select Progress Status", variant: .medium, size: 16)
                            .foregroundColor(.primary)

                        if statusOptions.isEmpty {
                            AppText("No task stages found", variant: .regular, size: 16)
                                .foregroundColor(.secondary)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(statusOptions) { option in
                                    Button(action: {
                                        onUpdateStatus(option)
                                        isPresented = false
                                    }) {
                                        HStack {
                                            AppText(option.stageName, variant: .bold, size: 18)
                                            Spacer()
                                            if task.stageId == option.stageId {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 20))
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(task.stageId == option.stageId ? Color.blue.opacity(0.1) : Color.clear)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(task.stageId == option.stageId ? Color.blue : Color.clear, lineWidth: 2)
                                                )
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    AppButton("Cancel") {
                        isPresented = false
                    }
                }
                .padding(20)
                .navigationTitle("Update Status")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let sampleTask = TaskEntity(id: 1, name: "Sample Task", stageId: 1, stageName: "New", deadline: "2026-03-15")
    
    return UpdateStatusSheet(
        isPresented: .constant(true),
        task: sampleTask,
        statusOptions: [
            TaskStatusOption(status: .pending, stageId: 1, stageName: "Inbox"),
            TaskStatusOption(status: .inProgress, stageId: 2, stageName: "Tasks"),
            TaskStatusOption(status: .completed, stageId: 3, stageName: "Done")
        ],
        onUpdateStatus: { option in
            print("Updated status to: \(option.stageName)")
        }
    )
}
