import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Binding var showSignUp: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                VStack(spacing: 16) {
                    inputFields

                    rememberMeAndForgot

                    if let error = authViewModel.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }

                    Button(action: authViewModel.signIn) {
                        Text("Sign in")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(FintrackTheme.primaryGreen)
                            .cornerRadius(12)
                    }

                    createAccountLink
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
                Text("Welcome back!")
                    .fintrackTitleStyle()
                Text("Sign in to continue")
                    .fintrackSubtitleStyle()
            }
        }
    }

    private var inputFields: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("E-mail")
                    .font(.subheadline)
                    .foregroundColor(FintrackTheme.textSecondary)
                TextField("Enter your email", text: $authViewModel.signInEmail)
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
                SecureField("Enter your password", text: $authViewModel.signInPassword)
                    .padding()
                    .background(FintrackTheme.cardBackground)
                    .cornerRadius(12)
                    .foregroundColor(FintrackTheme.textPrimary)
            }
        }
    }

    private var rememberMeAndForgot: some View {
        HStack {
            Toggle(isOn: $authViewModel.rememberMe) {
                Text("Remember me")
                    .font(.footnote)
                    .foregroundColor(FintrackTheme.textSecondary)
            }
            .toggleStyle(SwitchToggleStyle(tint: FintrackTheme.primaryGreen))

            Spacer()

            Button(action: {}) {
                Text("Forgot password?")
                    .font(.footnote)
                    .foregroundColor(FintrackTheme.primaryGreen)
            }
        }
    }

    private var createAccountLink: some View {
        HStack {
            Text("Don’t have an account?")
                .font(.footnote)
                .foregroundColor(FintrackTheme.textSecondary)
            Button(action: { showSignUp = true }) {
                Text("Create account")
                    .font(.footnote)
                    .foregroundColor(FintrackTheme.primaryGreen)
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    SignInView(showSignUp: .constant(false))
        .environmentObject(AuthViewModel())
}
