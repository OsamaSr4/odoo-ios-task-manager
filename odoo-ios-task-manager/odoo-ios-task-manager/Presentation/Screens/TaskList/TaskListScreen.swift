import SwiftUI

struct TaskListScreen: View {
    @State private var tasks: [Task] = Task.sampleTasks
    @State private var selectedTask: Task?
    @State private var username : String = "Osama Iqbal"
    
    @State private var showCreateTaskSheet = false
    @State private var showUpdateProfileSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // AppBar
            AppBar(title: "Tasks") {
                AvatarView.small(name: username) {
                    showUpdateProfileSheet.toggle()
                }
            } rightContent: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.primary)
                    .onTapGesture {
                        showCreateTaskSheet.toggle()
                    }
            }
            // Main content
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome message
                    VStack(alignment: .leading, spacing: 8) {
                        AppText("Welcome", variant: .bold, size: 24)
                            .foregroundColor(.primary)
                        
                        AppText(username, variant: .medium, size: 18)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    
                    // Task list
                    LazyVStack(spacing: 12) {
                        ForEach(tasks) { task in
                            TaskCell(task: task) {
                                selectedTask = task
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showUpdateProfileSheet) {
            UpdateProfileSheet(isPresented: $showUpdateProfileSheet, username: username) { updatedUsername in
                self.username = updatedUsername
            }
        }
        .sheet(isPresented: $showCreateTaskSheet) {
            CreateTaskSheet(
                isPresented: $showCreateTaskSheet,
                onCreateTask: handleTaskCreation
            )
        }
        .sheet(item: $selectedTask) { task in
            UpdateStatusSheet(
                isPresented: Binding(
                    get: { selectedTask != nil },
                    set: { isPresented in
                        if !isPresented {
                            selectedTask = nil
                        }
                    }
                ),
                task: task,
                onUpdateStatus: updateTaskStatus
            )
        }
    }
    
    private func handleTaskCreation(_ task: Task) {
        tasks.append(task)
    }
    
    private func updateTaskStatus(to status: TaskStatus) {
        guard let selectedTask = selectedTask else { return }
        
        if let index = tasks.firstIndex(where: { $0.id == selectedTask.id }) {
            tasks[index] = Task(
                id: selectedTask.id,
                title: selectedTask.title,
                description: selectedTask.description,
                status: status,
                dueDate: selectedTask.dueDate
            )
        }
    }
}

#Preview {
    TaskListScreen()
}
