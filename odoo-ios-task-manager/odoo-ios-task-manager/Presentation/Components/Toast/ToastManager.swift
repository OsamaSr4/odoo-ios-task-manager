import SwiftUI
import Combine

class ToastManager: ObservableObject {
    @Published var toasts: [ToastItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellables = [UUID: AnyCancellable]()
    
    func show(_ toast: ToastItem) {
        DispatchQueue.main.async { [weak self] in
            self?.toasts.append(toast)
            
            if toast.duration > 0 {
                self?.scheduleDismissal(for: toast)
            }
            
            if let type = toast.type {
                type.hapticType.trigger()
            }
        }
    }
    
    func showBuiltIn(
        type: ToastType,
        title: String? = nil,
        message: String,
        position: ToastPosition = .defaultPosition(for: DeviceType.current),
        duration: TimeInterval = 3.0,
        action: ToastAction? = nil,
        maxWidth: CGFloat? = nil
    ) {
        let toast = ToastItem.builtIn(
            type: type,
            title: title,
            message: message,
            position: position,
            duration: duration,
            action: action,
            maxWidth: maxWidth
        )
        show(toast)
    }
    
    func showCustom<Content: View>(
        view: Content,
        position: ToastPosition = .defaultPosition(for: DeviceType.current),
        duration: TimeInterval = 3.0,
        maxWidth: CGFloat? = nil
    ) {
        let toast = ToastItem.custom(
            view: view,
            position: position,
            duration: duration,
            maxWidth: maxWidth
        )
        show(toast)
    }
    
    func dismiss(_ toast: ToastItem) {
        DispatchQueue.main.async { [weak self] in
            if let index = self?.toasts.firstIndex(of: toast) {
                self?.toasts.remove(at: index)
            }
            self?.timerCancellables[toast.id]?.cancel()
            self?.timerCancellables.removeValue(forKey: toast.id)
        }
    }
    
    func dismissAll() {
        DispatchQueue.main.async { [weak self] in
            self?.toasts.removeAll()
            self?.timerCancellables.values.forEach { $0.cancel() }
            self?.timerCancellables.removeAll()
        }
    }
    
    private func scheduleDismissal(for toast: ToastItem) {
        timerCancellables[toast.id]?.cancel()
        
        timerCancellables[toast.id] = Just(())
            .delay(for: .seconds(toast.duration), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(toast)
            }
    }
}

extension ToastManager {
    func info(
        _ message: String,
        title: String? = nil,
        position: ToastPosition = .defaultPosition(for: DeviceType.current),
        duration: TimeInterval = 3.0,
        action: ToastAction? = nil
    ) {
        showBuiltIn(
            type: .info,
            title: title,
            message: message,
            position: position,
            duration: duration,
            action: action
        )
    }
    
    func success(
        _ message: String,
        title: String? = nil,
        position: ToastPosition = .defaultPosition(for: DeviceType.current),
        duration: TimeInterval = 3.0,
        action: ToastAction? = nil
    ) {
        showBuiltIn(
            type: .success,
            title: title,
            message: message,
            position: position,
            duration: duration,
            action: action
        )
    }
    
    func error(
        _ message: String,
        title: String? = nil,
        position: ToastPosition = .defaultPosition(for: DeviceType.current),
        duration: TimeInterval = 3.0,
        action: ToastAction? = nil
    ) {
        showBuiltIn(
            type: .error,
            title: title,
            message: message,
            position: position,
            duration: duration,
            action: action
        )
    }
    
    func warning(
        _ message: String,
        title: String? = nil,
        position: ToastPosition = .defaultPosition(for: DeviceType.current),
        duration: TimeInterval = 3.0,
        action: ToastAction? = nil
    ) {
        showBuiltIn(
            type: .warning,
            title: title,
            message: message,
            position: position,
            duration: duration,
            action: action
        )
    }
}
