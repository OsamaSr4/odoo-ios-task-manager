# Odoo iOS Task Manager

SwiftUI-based iOS application that integrates with Odoo ERP through JSON-RPC. The app authenticates an Odoo user, lists projects, displays project tasks, creates tasks, updates task status, and lets the user update their display name.

## Project Setup

### Requirements

- macOS with Xcode installed
- iOS Simulator or a physical iOS device
- Network access to the configured Odoo instance
- Valid Odoo database credentials with access to Projects and Tasks

The current Xcode project is configured with an iOS deployment target of `26.2`. If your local Xcode does not support that SDK, update the deployment target in Xcode before building.

### Run the App

1. Clone or open this repository.
2. Open the Xcode project:

   ```sh
   open odoo-ios-task-manager/odoo-ios-task-manager.xcodeproj
   ```

3. Review the Odoo configuration in:

   ```text
   odoo-ios-task-manager/odoo-ios-task-manager/Core/Constants/OdooConfig.swift
   ```

4. Update `baseURL`, `database`, and the default login values if needed.
5. Select the `odoo-ios-task-manager` scheme in Xcode.
6. Choose a simulator or connected device.
7. Build and run with `Cmd + R`.

### Tests

The repository includes default unit and UI test targets generated with the Xcode project. Run them from Xcode with `Cmd + U`, or use:

```sh
xcodebuild test \
  -project odoo-ios-task-manager/odoo-ios-task-manager.xcodeproj \
  -scheme odoo-ios-task-manager \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

Adjust the simulator name if that destination is not available locally.

## Architecture

The app follows an MVVM structure with a lightweight Clean Architecture separation between presentation, domain, and data layers.

```text
odoo-ios-task-manager/
  odoo-ios-task-manager/
    Core/
      Constants/
      DependencyInjection/
      Errors/
      Session/
    Data/
      DTOs/
      DataSources/
      Network/
      Repositories/
    Domain/
      Entities/
      Repositories/
      UseCases/
    Presentation/
      Components/
      Navigation/
      Screens/
      ViewModels/
```

### Presentation Layer

`Presentation` contains SwiftUI screens, reusable UI components, navigation, and view models.

- Screens such as `LoginScreenView`, `ProjectListScreen`, and `TaskListScreen` define the visible user interface.
- View models such as `LoginViewModel`, `ProjectListViewModel`, and `TaskViewModel` expose state with `@Published` properties and call domain use cases.
- Reusable components such as buttons, text fields, dropdowns, task cells, toasts, and navigation bars keep screen code smaller and consistent.

### Domain Layer

`Domain` contains app-level business contracts and use cases.

- Entities (`TaskEntity`, `ProjectEntity`, `TaskStageEntity`) represent the data used by the app UI.
- `OdooRepositoryProtocol` defines the operations the app needs without tying the domain to networking details.
- Use cases wrap individual actions such as login, fetching projects, fetching tasks, creating a task, updating task status, restoring a session, and updating the user name.

This layer makes the core workflow easier to test and keeps view models from knowing how Odoo JSON-RPC calls are built.

### Data Layer

`Data` implements the Odoo integration.

- `OdooNetworkClient` sends JSON-RPC requests using `URLSession`, handles cookies, decodes responses, logs request/response details, and maps Odoo errors into app errors.
- `OdooRemoteDataSource` contains the Odoo model/method calls, including `authenticate`, `search_read`, `create`, and `write`.
- DTOs parse the flexible JSON-RPC response payloads.
- `OdooRepositoryImpl` maps DTOs into domain entities, validates inputs, stores the active `uid` and password during runtime, and provides fallback behavior for task fetching.

### Core Layer

`Core` contains shared infrastructure.

- `OdooConfig` stores the configured Odoo URL, database, endpoint, and default login values.
- `AppDependencyContainer` wires the network client, remote data source, repository, use cases, and view models.
- `OdooSessionStore` persists session metadata with `UserDefaults` and stores the password in the iOS Keychain through the Security framework.
- `OdooError` centralizes user-facing and internal error cases.

## Libraries and Frameworks Used

This project does not use third-party package dependencies. It relies on Apple platform frameworks:

- `SwiftUI`: Used to build the app UI declaratively, including screens, reusable components, sheets, and navigation.
- `Combine`: Used through `ObservableObject` and `@Published` in view models so SwiftUI updates when app state changes.
- `Foundation`: Used for networking, JSON encoding/decoding, dates, URL handling, async/await support, and shared system types.
- `Security`: Used to store the Odoo password in Keychain instead of plain `UserDefaults`.
- `URLSession`: Used by `OdooNetworkClient` to perform JSON-RPC HTTP requests.
- `UserDefaults`: Used for lightweight persisted session metadata such as `uid` and username.

Avoiding third-party libraries keeps the assessment project simple to build, easier to review, and free from package resolution issues.

## Assumptions and Limitations

- Offline synchronization is not implemented in this version. The app requires network access to Odoo for login, project loading, task loading, task creation, status updates, and profile updates.
- The app targets a configured Odoo instance and database in `OdooConfig.swift`.
- Default credentials are present only to speed up assessment/demo login. In a production app, credentials should not be hardcoded.
- The app uses Odoo JSON-RPC directly instead of a custom backend service.
- Tasks are fetched for a selected project. The repository first tries to load tasks assigned to the logged-in user and falls back to project tasks when assigned-only results are unavailable or empty.
- Task status options are inferred from Odoo task stages by matching stage names such as pending, progress, and done/completed.
- The app currently limits fetched projects and stages to 50 records and tasks to 20 records per request.
- Local persistence is limited to session restoration. Tasks and projects are not cached locally.
- Conflict resolution, background refresh, push notifications, pagination, and advanced search/filtering are outside the scope of this version.

## Main User Flow

1. User logs in with Odoo credentials.
2. The app stores the authenticated session for restoration.
3. User selects a project.
4. The app loads task stages and tasks for that project.
5. User can create a task, update task status, or update their display name.
6. Changes are sent directly to Odoo through JSON-RPC.
