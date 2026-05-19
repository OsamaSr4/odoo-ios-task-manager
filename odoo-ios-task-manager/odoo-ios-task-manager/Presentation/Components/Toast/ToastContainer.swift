import SwiftUI

struct ToastContainer: View {
    @ObservedObject var toastManager: ToastManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ForEach(toastManager.toasts) { toast in
                    ToastView(item: toast) {
                        toastManager.dismiss(toast)
                    }
                    .position(
                        x: positionX(for: toast, in: geometry),
                        y: positionY(for: toast, in: geometry)
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: insertionEdge(for: toast)).combined(with: .opacity),
                        removal: .move(edge: removalEdge(for: toast)).combined(with: .opacity)
                    ))
                }
            }
            .ignoresSafeArea()
        }
    }
    
    private func positionX(for toast: ToastItem, in geometry: GeometryProxy) -> CGFloat {
        let device = DeviceType.current
        let alignment = toast.position.alignment(for: device)
        let offset = toast.position.offset(for: device)
        
        switch alignment {
        case .leading, .topLeading, .bottomLeading:
            return geometry.size.width * 0.25 + offset.width
        case .trailing, .topTrailing, .bottomTrailing:
            return geometry.size.width * 0.75 + offset.width
        case .center, .top, .bottom:
            return geometry.size.width * 0.5 + offset.width
        default:
            return geometry.size.width * 0.5
        }
    }
    
    private func positionY(for toast: ToastItem, in geometry: GeometryProxy) -> CGFloat {
        let device = DeviceType.current
        let alignment = toast.position.alignment(for: device)
        let offset = toast.position.offset(for: device)
        
        switch alignment {
        case .top, .topLeading, .topTrailing:
            return safeAreaTop(for: geometry) + offset.height
        case .bottom, .bottomLeading, .bottomTrailing:
            return geometry.size.height - safeAreaBottom(for: geometry) + offset.height
        case .center, .leading, .trailing:
            return geometry.size.height * 0.5 + offset.height
        default:
            return geometry.size.height * 0.5
        }
    }
    
    private func insertionEdge(for toast: ToastItem) -> Edge {
        let device = DeviceType.current
        let alignment = toast.position.alignment(for: device)
        
        switch alignment {
        case .top, .topLeading, .topTrailing:
            return .top
        case .bottom, .bottomLeading, .bottomTrailing:
            return .bottom
        default:
            return .top
        }
    }
    
    private func removalEdge(for toast: ToastItem) -> Edge {
        let device = DeviceType.current
        let alignment = toast.position.alignment(for: device)
        
        switch alignment {
        case .top, .topLeading, .topTrailing:
            return .top
        case .bottom, .bottomLeading, .bottomTrailing:
            return .bottom
        default:
            return .top
        }
    }
    
    private func safeAreaTop(for geometry: GeometryProxy) -> CGFloat {
        return geometry.safeAreaInsets.top
    }
    
    private func safeAreaBottom(for geometry: GeometryProxy) -> CGFloat {
        return geometry.safeAreaInsets.bottom
    }
}

#Preview {
    VStack {
        Spacer()
        
        ToastContainer(
            toastManager: ToastManager()
        )
        .onAppear {
            let manager = ToastManager()
            manager.info("Info message", position: .top)
            manager.success("Success message", position: .bottom)
            manager.error("Error message", position: .center)
        }
        
        Spacer()
    }
}
