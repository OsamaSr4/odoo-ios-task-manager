import SwiftUI

struct TaskListScreen: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var selectedTask: TaskEntity?
    
    @State private var showCreateTaskSheet = false
    @State private var showUpdateProfileSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // AppBar
            AppBar(title: "Tasks") {
                AvatarView.small(name: viewModel.username) {
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
                        
                        AppText(viewModel.username, variant: .medium, size: 18)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    
                    // Task list
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.tasks) { task in
                            TaskCell(task: task) {
                                selectedTask = task
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    if viewModel.tasks.isEmpty && !viewModel.isLoading {
                        AppText("No tasks found", variant: .regular)
                            .foregroundColor(.secondary)
                            .padding(.top, 24)
                    }
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
            if let errorMessage = viewModel.errorMessage {
                AppText(errorMessage, variant: .regular, color: .red)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
        }
        .navigationBarHidden(true)
        .task {
            if viewModel.tasks.isEmpty {
                await viewModel.loadTasks()
            }
        }
        .sheet(isPresented: $showUpdateProfileSheet) {
            UpdateProfileSheet(isPresented: $showUpdateProfileSheet, username: viewModel.username) { updatedUsername in
                _Concurrency.Task {
                    await viewModel.updateUserName(name: updatedUsername)
                }
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
                statusOptions: viewModel.taskStatusOptions,
                onUpdateStatus: updateTaskStatus
            )
        }
    }

    private func handleTaskCreation(name: String, description: String, deadline: String) {
        _Concurrency.Task {
            await viewModel.createTask(
                name: name,
                description: description,
                projectId: OdooConfig.defaultProjectId,
                deadline: deadline
            )
        }
    }

    private func updateTaskStatus(to option: TaskStatusOption) {
        guard let selectedTask else { return }

        _Concurrency.Task {
            await viewModel.updateStatus(taskId: selectedTask.id, stageId: option.stageId)
        }
    }
}

#Preview {
    TaskListScreen(viewModel: AppDependencyContainer.makeTaskViewModel())
}
