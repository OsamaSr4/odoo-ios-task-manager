import SwiftUI

struct LoginScreenView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var selectedRole = "Employee"
    private let onLogin: (String, String) -> Void
    
    init(onLogin: @escaping (String, String) -> Void = { _, _ in }) {
        self.onLogin = onLogin
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                loginFormSection
                footerSection
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 8) {
                AppText("Welcome Back!", variant: .bold)
                    .multilineTextAlignment(.center)
                
                AppText("Login to your account to continue", variant: .regular)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 40)
        .padding(.bottom, 32)
    }
    
    private var loginFormSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                AppTextField(
                    text: $email,
                    placeholder: "Email Address",
                    leadingIcon: Image(systemName: "envelope")
                )
                
                AppTextField(
                    text: $password,
                    placeholder: "Password",
                    isSecure: true,
                    leadingIcon: Image(systemName: "lock")
                )
            }
            AppButton("Login", variant: .primary) {
                onLogin(email, password)
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 16)
    }
    
    private var footerSection: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                AppText("Or login with", variant: .regular)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Image(systemName: "globe")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {}) {
                        Image(systemName: "applelogo")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {}) {
                        Image(systemName: "faceid")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
        }
        .padding(.top, 32)
    }
}

#Preview {
    NavigationView {
        LoginScreenView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationView {
        LoginScreenView()
    }
    .preferredColorScheme(.dark)
    .background(Color.black)
}

