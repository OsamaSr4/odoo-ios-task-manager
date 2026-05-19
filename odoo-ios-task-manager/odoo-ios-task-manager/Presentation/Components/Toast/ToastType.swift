import SwiftUI

enum ToastType {
    case info
    case success
    case error
    case warning
    
    var backgroundColor: Color {
        switch self {
        case .info:
            return Color.blue
        case .success:
            return Color.green
        case .error:
            return Color.red
        case .warning:
            return Color.orange
        }
    }
    
    var foregroundColor: Color {
        return Color.white
    }
    
    var icon: String {
        switch self {
        case .info:
            return "info.circle.fill"
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        }
    }
    
    var hapticType: HapticFeedbackType {
        switch self {
        case .info:
            return .light
        case .success:
            return .success
        case .error:
            return .error
        case .warning:
            return .warning
        }
    }
}

enum HapticFeedbackType {
    case light
    case success
    case error
    case warning
    
    func trigger() {
        let generator: UINotificationFeedbackGenerator
        
        switch self {
        case .light:
            let impactGenerator = UIImpactFeedbackGenerator(style: .light)
            impactGenerator.impactOccurred()
            return
        case .success:
            generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .error:
            generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .warning:
            generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
    }
}
