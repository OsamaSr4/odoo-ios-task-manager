import SwiftUI

struct AppBar: View {
    let title: String
    private let leftContent: AnyView
    private let rightContent: AnyView

    init(
        title: String,
        onBackPressed: (() -> Void)? = nil
    ) {
        self.title = title
        self.leftContent = AnyView(AppBarBackButton(action: onBackPressed))
        self.rightContent = AnyView(Color.clear)
    }

    init<LeftContent: View, RightContent: View>(
        title: String,
        @ViewBuilder leftContent: () -> LeftContent,
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self.title = title
        self.leftContent = AnyView(leftContent())
        self.rightContent = AnyView(rightContent())
    }

    init<RightContent: View>(
        title: String,
        showBackButton: Bool = true,
        onBackPressed: (() -> Void)? = nil,
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self.title = title
        self.leftContent = showBackButton
            ? AnyView(AppBarBackButton(action: onBackPressed))
            : AnyView(Color.clear)
        self.rightContent = AnyView(rightContent())
    }

    init<LeftContent: View>(
        title: String,
        @ViewBuilder leftContent: () -> LeftContent
    ) {
        self.title = title
        self.leftContent = AnyView(leftContent())
        self.rightContent = AnyView(Color.clear)
    }

    init(
        title: String,
        showBackButton: Bool = true,
        rightButtonIcon: Image? = nil,
        rightButtonAction: (() -> Void)? = nil,
        onBackPressed: (() -> Void)? = nil
    ) {
        self.title = title
        self.leftContent = showBackButton
            ? AnyView(AppBarBackButton(action: onBackPressed))
            : AnyView(Color.clear)

        if let rightButtonIcon {
            self.rightContent = AnyView(
                Button(action: rightButtonAction ?? {}) {
                    rightButtonIcon
                }
            )
        } else {
            self.rightContent = AnyView(Color.clear)
        }
    }

    var body: some View {
        HStack {
            barItem(leftContent)

            Spacer()

            AppText(title, variant: .bold)
                .multilineTextAlignment(.center)

            Spacer()

            barItem(rightContent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        )
    }

    private func barItem(_ content: AnyView) -> some View {
        content
            .font(.title2)
            .foregroundColor(.primary)
            .frame(width: 44, height: 44)
    }
}

private struct AppBarBackButton: View {
    let action: (() -> Void)?

    var body: some View {
        Button(action: action ?? {}) {
            Image(systemName: "chevron.left")
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        AppBar(title: "Login Screen")

        Divider()

        AppBar(
            title: "Task List",
            showBackButton: false,
            rightButtonIcon: Image(systemName: "plus"),
            rightButtonAction: {
                print("Add task")
            }
        )

        Divider()

        AppBar(
            title: "Settings",
            rightButtonIcon: Image(systemName: "ellipsis"),
            rightButtonAction: {
                print("More options")
            }
        )

        Divider()

        AppBar(title: "Custom") {
            Button(action: {}) {
                Image(systemName: "xmark")
            }
        } rightContent: {
            Button(action: {}) {
                AppText("Done", variant: .medium, color: .blue)
            }
        }

        Spacer()
    }
    .ignoresSafeArea(edges: .bottom)
}
