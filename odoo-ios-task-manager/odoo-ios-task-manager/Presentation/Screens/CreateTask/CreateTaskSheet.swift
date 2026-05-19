import SwiftUI

struct CreateTaskSheet: View {
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = Date()
    
    let onCreateTask: (Task) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Title field
                VStack(alignment: .leading, spacing: 8) {
                    AppText("Title", variant: .medium, size: 16)
                        .foregroundColor(.primary)
                    
                    AppTextField(
                        text: $title,
                        placeholder: "Enter task title"
                    )
                }
                
                // Description field
                VStack(alignment: .leading, spacing: 8) {
                    AppText("Description", variant: .medium, size: 16)
                        .foregroundColor(.primary)
                    
                    AppTextField(
                        text: $description,
                        placeholder: "Enter task description"
                    )
                }
                
                // Due date field
                VStack(alignment: .leading, spacing: 8) {
                    AppText("Due Date", variant: .medium, size: 16)
                        .foregroundColor(.primary)
                    
                    DatePicker("Select due date", selection: $dueDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
                
                Spacer()
                
                // Create task button
                AppButton(
                    "Create Task",
                    action: {
                        let newTask = Task(
                            title: title,
                            description: description,
                            status: .pending,
                            dueDate: dueDate
                        )
                        onCreateTask(newTask)
                        isPresented = false
                        resetFields()
                    }
                )
                .padding(.bottom)
                .disabled(title.isEmpty || description.isEmpty)
            }
            .padding(20)
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                        resetFields()
                    }
                }
            }
        }
    }
    
    private var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: dueDate)
    }
    
    private func resetFields() {
        title = ""
        description = ""
        dueDate = Date()
    }
}

#Preview {
    @State var isPresented = true
    
    return CreateTaskSheet(
        isPresented: $isPresented,
        onCreateTask: { task in
            print("Created task: \(task.title)")
        }
    )
}
