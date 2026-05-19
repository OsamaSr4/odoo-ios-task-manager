import SwiftUI

class ToastItem: Identifiable, Equatable {
    let id = UUID()
    let type: ToastType?
    let title: String?
    let message: String?
    let position: ToastPosition
    let duration: TimeInterval
    let action: ToastAction?
    let customView: AnyView?
    let maxWidth: CGFloat?
    let createdAt: Date
    
    init(
        type: ToastType? = nil,
        title: String? = nil,
        message: String? = nil,
        position: ToastPosition = .defaultPosition(for: DeviceType.current),
        duration: TimeInterval = 3.0,
        action: ToastAction? = nil,
        customView: AnyView? = nil,
        maxWidth: CGFloat? = nil
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.position = position
        self.duration = duration
        self.action = action
        self.customView = customView
        self.maxWidth = maxWidth
        self.createdAt = Date()
    }
    
    static func == (lhs: ToastItem, rhs: ToastItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    var isBuiltIn: Bool {
        return customView == nil && type != nil
    }
    
    var isCustom: Bool {
        return customView != nil
    }
}

struct ToastAction {
    let title: String
    let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}

extension ToastItem {
    static func builtIn(
        type: ToastType,
        title: String? = nil,
        message: String,
        position: ToastPosition = .defaultPosition(for: DeviceType.current),
        duration: TimeInterval = 3.0,
        action: ToastAction? = nil,
        maxWidth: CGFloat? = nil
    ) -> ToastItem {
        return ToastItem(
            type: type,
            title: title,
            message: message,
            position: position,
            duration: duration,
            action: action,
            maxWidth: maxWidth
        )
    }
    
    static func custom<Content: View>(
        view: Content,
        position: ToastPosition = .defaultPosition(for: DeviceType.current),
        duration: TimeInterval = 3.0,
        maxWidth: CGFloat? = nil
    ) -> ToastItem {
        return ToastItem(
            position: position,
            duration: duration,
            customView: AnyView(view),
            maxWidth: maxWidth
        )
    }
}
