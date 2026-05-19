import SwiftUI

struct UpdateProfileSheet: View {
    @Binding var isPresented: Bool
    @State private var username: String

    let onUpdateUsername: (String) -> Void

    init(
        isPresented: Binding<Bool>,
        username: String,
        onUpdateUsername: @escaping (String) -> Void
    ) {
        self._isPresented = isPresented
        self._username = State(initialValue: username)
        self.onUpdateUsername = onUpdateUsername
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    AppText("Username", variant: .medium, size: 16)
                        .foregroundColor(.primary)

                    AppTextField(
                        text: $username,
                        placeholder: "Enter username",
                        leadingIcon: Image(systemName: "person")
                    )
                }

                Spacer()

                AppButton(
                    "Update Profile",
                    isDisabled: trimmedUsername.isEmpty,
                    action: {
                        onUpdateUsername(trimmedUsername)
                        isPresented = false
                    }
                )
                .padding(.bottom)
            }
            .padding(20)
            .navigationTitle("Update Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }

    private var trimmedUsername: String {
        username.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    @State var isPresented = true

    return UpdateProfileSheet(
        isPresented: $isPresented,
        username: "Guest User",
        onUpdateUsername: { username in
            print("Updated username to: \(username)")
        }
    )
}
