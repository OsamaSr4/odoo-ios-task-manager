import SwiftUI

struct AppText: View {
    let text: String
    let variant: AppTextVariant
    let color: Color
    let alignment: TextAlignment
    
    init(
        _ text: String,
        variant: AppTextVariant = .regular,
        color: Color = .primary,
        alignment: TextAlignment = .leading
    ) {
        self.text = text
        self.variant = variant
        self.color = color
        self.alignment = alignment
    }
    
    var body: some View {
        Text(text)
            .font(variant.font)
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
    }
}

enum AppTextVariant {
    case bold
    case medium
    case regular
    
    var font: Font {
        switch self {
        case .bold:
            return .system(size: 16, weight: .bold)
        case .medium:
            return .system(size: 16, weight: .medium)
        case .regular:
            return .system(size: 16, weight: .regular)
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
    }
    .padding()
}
