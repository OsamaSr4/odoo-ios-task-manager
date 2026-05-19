import SwiftUI

struct ToastModifier: ViewModifier {
    @StateObject private var toastManager = ToastManager()
    
    func body(content: Content) -> some View {
        content
            .environmentObject(toastManager)
            .overlay(
                ToastContainer(toastManager: toastManager)
            )
    }
}

extension View {
    func toast() -> some View {
        modifier(ToastModifier())
    }
}


struct ToastKey: EnvironmentKey {
    static let defaultValue: ToastManager? = nil
}

extension EnvironmentValues {
    var toastManager: ToastManager? {
        get { self[ToastKey.self] }
        set { self[ToastKey.self] = newValue }
    }
}

extension View {
    func withToastManager() -> some View {
        modifier(ToastModifier())
    }
}

#Preview {
    VStack(spacing: 20) {
        Button("Show Success") {
            let manager = ToastManager()
            manager.success("Task completed successfully!")
        }
        .buttonStyle(.borderedProminent)
        
        Button("Show Custom") {
            let manager = ToastManager()
            manager.showCustom(
                view: HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Custom Toast")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            )
        }
        .buttonStyle(.bordered)
    }
    .padding()
    .withToastManager()
}
