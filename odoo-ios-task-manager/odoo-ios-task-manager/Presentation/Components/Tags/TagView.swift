import SwiftUI

struct TagView: View {
    let title: String
    let backgroundColor: Color
    let textColor: Color
    let isSelected: Bool
    let isSelectable: Bool
    let onTap: (() -> Void)?
    
    init(
        _ title: String,
        backgroundColor: Color = .blue.opacity(0.1),
        textColor: Color = .blue,
        isSelected: Bool = false,
        isSelectable: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.isSelected = isSelected
        self.isSelectable = isSelectable
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            AppText(
                title,
                variant: .medium,
                color: actualTextColor
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(actualBackgroundColor)
                    .overlay(
                        Capsule()
                            .stroke(actualBorderColor, lineWidth: isSelected ? 2 : 0)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isSelectable)
    }
    
    private var actualBackgroundColor: Color {
        if isSelected {
            return textColor
        }
        return backgroundColor
    }
    
    private var actualTextColor: Color {
        if isSelected {
            return .white
        }
        return textColor
    }
    
    private var actualBorderColor: Color {
        if isSelected {
            return textColor
        }
        return Color.clear
    }
}

#Preview {
    VStack(spacing: 20) {
        VStack(spacing: 10) {
            AppText("Static Tags", variant: .bold)
            
            HStack(spacing: 8) {
                TagView("SwiftUI")
                TagView("iOS", backgroundColor: .green.opacity(0.1), textColor: .green)
                TagView("Swift", backgroundColor: .orange.opacity(0.1), textColor: .orange)
            }
        }
        
        VStack(spacing: 10) {
            AppText("Selectable Tags", variant: .bold)
            
            HStack(spacing: 8) {
                TagView("Option 1", isSelected: true, isSelectable: true)
                TagView("Option 2", isSelectable: true)
                TagView("Option 3", isSelectable: true)
            }
        }
        
        VStack(spacing: 10) {
            AppText("Different Colors", variant: .bold)
            
            HStack(spacing: 8) {
                TagView("Primary", backgroundColor: .blue.opacity(0.1), textColor: .blue)
                TagView("Success", backgroundColor: .green.opacity(0.1), textColor: .green)
                TagView("Warning", backgroundColor: .yellow.opacity(0.1), textColor: .orange)
                TagView("Error", backgroundColor: .red.opacity(0.1), textColor: .red)
            }
        }
    }
    .padding()
}
