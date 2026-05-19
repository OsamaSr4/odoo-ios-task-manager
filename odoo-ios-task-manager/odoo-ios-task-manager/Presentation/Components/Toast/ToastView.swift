import SwiftUI

struct ToastView: View {
    let item: ToastItem
    let onDismiss: () -> Void
    
    @State private var isVisible = false
    @State private var offset: CGFloat = 0
    
    init(item: ToastItem, onDismiss: @escaping () -> Void) {
        self.item = item
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        Group {
            if item.isCustom, let customView = item.customView {
                customView
                    .frame(maxWidth: item.maxWidth)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
            } else if item.isBuiltIn, let type = item.type {
                builtInToastView(type: type)
            }
        }
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .opacity(isVisible ? 1.0 : 0.0)
        .offset(y: offset)
        .onAppear {
            animateAppearance()
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if abs(value.translation.height) > 50 {
                        onDismiss()
                    }
                }
        )
    }
    
    @ViewBuilder
    private func builtInToastView(type: ToastType) -> some View {
        HStack(spacing: 12) {
            Image(systemName: type.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(type.foregroundColor)
            
            VStack(alignment: .leading, spacing: 2) {
                if let title = item.title {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(type.foregroundColor)
                }
                
                if let message = item.message {
                    Text(message)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(type.foregroundColor)
                        .lineLimit(3)
                }
            }
            
            Spacer(minLength: 8)
            
            if let action = item.action {
                Button(action: {
                    action.action()
                    onDismiss()
                }) {
                    Text(action.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(type.foregroundColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.2))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(type.foregroundColor.opacity(0.8))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(type.backgroundColor)
                .shadow(color: type.backgroundColor.opacity(0.3), radius: 8, x: 0, y: 4)
        )
        .frame(maxWidth: item.maxWidth ?? 280)
    }
    
    private func animateAppearance() {
        let device = DeviceType.current
        let alignment = item.position.alignment(for: device)
        
        switch alignment {
        case .top, .topLeading, .topTrailing:
            offset = -100
        case .bottom, .bottomLeading, .bottomTrailing:
            offset = 100
        default:
            offset = 0
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isVisible = true
            offset = 0
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ToastView(
            item: ToastItem.builtIn(
                type: .success,
                title: "Success",
                message: "Task created successfully"
            )
        ) {
            print("Dismissed")
        }
        
        ToastView(
            item: ToastItem.builtIn(
                type: .error,
                message: "Something went wrong",
                action: ToastAction(title: "Retry") {
                    print("Retry tapped")
                }
            )
        ) {
            print("Dismissed")
        }
        
        ToastView(
            item: ToastItem.custom(
                view: HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    VStack(alignment: .leading) {
                        Text("Premium Activated")
                            .font(.headline)
                        Text("You now have access to all features.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            )
        ) {
            print("Dismissed")
        }
    }
    .padding()
}
