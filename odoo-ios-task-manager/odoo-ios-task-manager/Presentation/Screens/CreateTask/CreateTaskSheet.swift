import SwiftUI

struct CreateTaskSheet: View {
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = Date()
    
    let onCreateTask: (String, String, String) -> Void
    
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
                        onCreateTask(title, description, formattedDueDate)
                        isPresented = false
                        resetFields()
                    }
                )
                .padding(.bottom)
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: dueDate)
    }
    
    private func resetFields() {
        title = ""
        description = ""
        dueDate = Date()
    }
}

#Preview {
    CreateTaskSheet(
        isPresented: .constant(true),
        onCreateTask: { name, description, deadline in
            print("Created task: \(name), description: \(description), deadline: \(deadline)")
        }
    )
}
