import SwiftUI

struct AppTextField: View {
    @Binding var text: String
    let placeholder: String
    let isSecure: Bool
    let errorMessage: String?
    let leadingIcon: Image?
    let trailingIcon: Image?
    let onTrailingIconTap: (() -> Void)?
    
    @State private var isPasswordVisible = false
    @State private var isFocused = false
    
    init(
        text: Binding<String>,
        placeholder: String,
        isSecure: Bool = false,
        errorMessage: String? = nil,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        onTrailingIconTap: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.errorMessage = errorMessage
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.onTrailingIconTap = onTrailingIconTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                if let leadingIcon {
                    leadingIcon
                        .foregroundColor(.gray)
                        .frame(width: 20, height: 20)
                }
                
                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .textFieldStyle(PlainTextFieldStyle())
                .onTapGesture {
                    isFocused = true
                }
                
                if isSecure {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                
                if let trailingIcon {
                    Button(action: onTrailingIconTap ?? {}) {
                        trailingIcon
                            .foregroundColor(.gray)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                errorMessage != nil ? Color.red : (isFocused ? Color.blue : Color.gray.opacity(0.3)),
                                lineWidth: errorMessage != nil ? 2 : 1
                            )
                    )
            )
            
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                AppText(errorMessage, variant: .regular, color: .red)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AppTextField(
            text: .constant(""),
            placeholder: "Enter your name",
            leadingIcon: Image(systemName: "person")
        )
        
        AppTextField(
            text: .constant("password123"),
            placeholder: "Enter password",
            isSecure: true,
            leadingIcon: Image(systemName: "lock")
        )
        
        AppTextField(
            text: .constant("invalid@email"),
            placeholder: "Enter email",
            errorMessage: "Please enter a valid email address",
            leadingIcon: Image(systemName: "envelope")
        )
        
        AppTextField(
            text: .constant("search text"),
            placeholder: "Search...",
            trailingIcon: Image(systemName: "xmark.circle"),
            onTrailingIconTap: {
                print("Clear search")
            }
        )
    }
    .padding()
}
