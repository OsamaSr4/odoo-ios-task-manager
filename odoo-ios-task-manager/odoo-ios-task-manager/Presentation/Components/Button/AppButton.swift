import SwiftUI

struct AppButton: View {
    let title: String
    let variant: AppButtonVariant
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        _ title: String,
        variant: AppButtonVariant = .primary,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: variant.contentColor))
                        .scaleEffect(0.8)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(variant.contentColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(variant.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(variant.borderColor, lineWidth: variant.borderWidth)
                    )
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

enum AppButtonVariant {
    case primary
    case secondary
    case outline
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return .blue
        case .secondary:
            return .gray.opacity(0.2)
        case .outline:
            return Color.clear
        }
    }
    
    var contentColor: Color {
        switch self {
        case .primary:
            return .white
        case .secondary:
            return .primary
        case .outline:
            return .blue
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary, .secondary:
            return Color.clear
        case .outline:
            return .blue
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .primary, .secondary:
            return 0
        case .outline:
            return 1
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Group {
            AppButton("Primary Button", variant: .primary) {
                print("Primary tapped")
            }
            
            AppButton("Secondary Button", variant: .secondary) {
                print("Secondary tapped")
            }
            
            AppButton("Outline Button", variant: .outline) {
                print("Outline tapped")
            }
        }
        
        Group {
            AppButton("Loading Primary", variant: .primary, isLoading: true) {
                print("Loading tapped")
            }
            
            AppButton("Disabled Button", variant: .primary, isDisabled: true) {
                print("Disabled tapped")
            }
        }
    }
    .padding()
}
