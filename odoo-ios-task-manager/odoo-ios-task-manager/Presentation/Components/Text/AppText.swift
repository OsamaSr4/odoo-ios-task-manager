import SwiftUI

struct AppText: View {
    let text: String
    let variant: AppTextVariant
    let color: Color
    let alignment: TextAlignment
    let size: CGFloat
    
    init(
        _ text: String,
        variant: AppTextVariant = .regular,
        color: Color = .primary,
        alignment: TextAlignment = .leading,
        size: CGFloat = 16
    ) {
        self.text = text
        self.variant = variant
        self.color = color
        self.alignment = alignment
        self.size = size
    }
    
    var body: some View {
        Text(text)
            .font(variant.font(size: size))
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
    }
}

enum AppTextVariant {
    case bold
    case medium
    case regular
    
    func font(size: CGFloat = 16) -> Font {
        switch self {
        case .bold:
            return .system(size: size, weight: .bold)
        case .medium:
            return .system(size: size, weight: .medium)
        case .regular:
            return .system(size: size, weight: .regular)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Group {
            AppText("Bold Text", variant: .bold)
            AppText("Medium Text", variant: .medium)
            AppText("Regular Text", variant: .regular)
        }
        
        Group {
            AppText("Primary Color", color: .primary)
            AppText("Blue Color", color: .blue)
            AppText("Red Color", color: .red)
        }
        
        Group {
            AppText("Leading Alignment", alignment: .leading)
                .frame(maxWidth: .infinity)
            AppText("Center Alignment", alignment: .center)
                .frame(maxWidth: .infinity)
            AppText("Trailing Alignment", alignment: .trailing)
                .frame(maxWidth: .infinity)
        }
        
        Group {
            AppText("Small Text", size: 12)
            AppText("Default Text", size: 16)
            AppText("Large Text", size: 20)
            AppText("Extra Large Text", size: 24)
        }
    }
    .padding()
}
