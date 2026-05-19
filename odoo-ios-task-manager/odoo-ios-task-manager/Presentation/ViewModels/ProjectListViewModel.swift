import Foundation
import Combine

@MainActor
final class ProjectListViewModel: ObservableObject {
    @Published private(set) var projects: [ProjectEntity] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let fetchProjectsUseCase: FetchProjectsUseCase

    init(fetchProjectsUseCase: FetchProjectsUseCase) {
        self.fetchProjectsUseCase = fetchProjectsUseCase
    }

    func loadProjects() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            projects = try await fetchProjectsUseCase.execute()
        } catch let error as OdooError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
