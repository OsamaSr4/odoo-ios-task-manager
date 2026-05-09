import SwiftUI

struct AppBar: View {
    let title: String
    let showBackButton: Bool
    let rightButtonIcon: Image?
    let rightButtonAction: (() -> Void)?
    let onBackPressed: (() -> Void)?
    
    init(
        title: String,
        showBackButton: Bool = false,
        rightButtonIcon: Image? = nil,
        rightButtonAction: (() -> Void)? = nil,
        onBackPressed: (() -> Void)? = nil
    ) {
        self.title = title
        self.showBackButton = showBackButton
        self.rightButtonIcon = rightButtonIcon
        self.rightButtonAction = rightButtonAction
        self.onBackPressed = onBackPressed
    }
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: onBackPressed ?? {}) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            } else {
                Spacer()
                    .frame(width: 44)
            }
            
            Spacer()
            
            AppText(title, variant: .bold)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            if let rightButtonIcon = rightButtonIcon {
                Button(action: rightButtonAction ?? {}) {
                    rightButtonIcon
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            } else {
                Spacer()
                    .frame(width: 44)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        )
    }
}

#Preview {
    VStack(spacing: 0) {
        AppBar(
            title: "Login Screen",
            showBackButton: true
        )
        
        Divider()
        
        AppBar(
            title: "Task List",
            rightButtonIcon: Image(systemName: "plus"),
            rightButtonAction: {
                print("Add task")
            }
        )
        
        Divider()
        
        AppBar(
            title: "Settings",
            showBackButton: true,
            rightButtonIcon: Image(systemName: "ellipsis"),
            rightButtonAction: {
                print("More options")
            }
        )
        
        Spacer()
    }
    .ignoresSafeArea(edges: .bottom)
}
