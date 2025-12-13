import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Binding var showSignUp: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                VStack(spacing: 16) {
                    inputFields

                    if let error = authViewModel.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }

                    Button(action: authViewModel.signUp) {
                        Text("Create account")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(FintrackTheme.primaryGreen)
                            .cornerRadius(12)
                    }

                    signInLink
                }
            }
            .padding(24)
        }
        .background(FintrackTheme.background.ignoresSafeArea())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("fintrack")
                .font(.headline.weight(.semibold))
                .foregroundColor(FintrackTheme.primaryGreen)

            VStack(alignment: .leading, spacing: 4) {
                Text("Sign up!")
                    .fintrackTitleStyle()
                Text("Create a new account to get started")
                    .fintrackSubtitleStyle()
            }
        }
    }

    private var inputFields: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Full name")
                    .font(.subheadline)
                    .foregroundColor(FintrackTheme.textSecondary)
                TextField("Enter your full name", text: $authViewModel.fullName)
                    .textInputAutocapitalization(.words)
                    .padding()
                    .background(FintrackTheme.cardBackground)
                    .cornerRadius(12)
                    .foregroundColor(FintrackTheme.textPrimary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("E-mail")
                    .font(.subheadline)
                    .foregroundColor(FintrackTheme.textSecondary)
                TextField("Enter your email", text: $authViewModel.signUpEmail)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .padding()
                    .background(FintrackTheme.cardBackground)
                    .cornerRadius(12)
                    .foregroundColor(FintrackTheme.textPrimary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.subheadline)
                    .foregroundColor(FintrackTheme.textSecondary)
                SecureField("Enter your password", text: $authViewModel.signUpPassword)
                    .padding()
                    .background(FintrackTheme.cardBackground)
                    .cornerRadius(12)
                    .foregroundColor(FintrackTheme.textPrimary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Phone number")
                    .font(.subheadline)
                    .foregroundColor(FintrackTheme.textSecondary)
                TextField("+1 000 000 0000", text: $authViewModel.phoneNumber)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(FintrackTheme.cardBackground)
                    .cornerRadius(12)
                    .foregroundColor(FintrackTheme.textPrimary)
            }
        }
    }

    private var signInLink: some View {
        HStack {
            Text("Already have an account?")
                .font(.footnote)
                .foregroundColor(FintrackTheme.textSecondary)
            Button(action: { showSignUp = false }) {
                Text("Sign in")
                    .font(.footnote)
                    .foregroundColor(FintrackTheme.primaryGreen)
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    SignUpView(showSignUp: .constant(true))
        .environmentObject(AuthViewModel())
}
