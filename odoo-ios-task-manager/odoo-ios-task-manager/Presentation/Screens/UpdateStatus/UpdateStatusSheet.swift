import SwiftUI

struct UpdateStatusSheet: View {
    @Binding var isPresented: Bool
    let task: Task
    let onUpdateStatus: (TaskStatus) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 24) {
                    // Status options
                    VStack(alignment: .leading, spacing: 12) {
                        AppText("Select New Status", variant: .medium, size: 16)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 8) {
                            ForEach(TaskStatus.allCases, id: \.self) { status in
                                Button(action: {
                                    onUpdateStatus(status)
                                    isPresented = false
                                }) {
                                    HStack {
                                        AppText(status.displayName,variant: .bold,size:18)
                                        Spacer()
                                        if task.status == status {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 20))
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(task.status == status ? Color.blue.opacity(0.1) : Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(task.status == status ? Color.blue : Color.clear, lineWidth: 2)
                                            )
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
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
    @State var isPresented = true
    let sampleTask = Task.sampleTasks[0]
    
    return UpdateStatusSheet(
        isPresented: $isPresented,
        task: sampleTask,
        onUpdateStatus: { status in
            print("Updated status to: \(status.displayName)")
        }
    )
}
