import SwiftUI

final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false

    // Sign in fields
    @Published var signInEmail: String = ""
    @Published var signInPassword: String = ""
    @Published var rememberMe: Bool = false

    // Sign up fields
    @Published var fullName: String = ""
    @Published var signUpEmail: String = ""
    @Published var signUpPassword: String = ""
    @Published var phoneNumber: String = ""

    // Simple error message placeholder
    @Published var errorMessage: String? = nil

    func signIn() {
        // Mock implementation for now
        errorMessage = nil
        guard !signInEmail.isEmpty, !signInPassword.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }
        // Simulate success
        isAuthenticated = true
    }

    func signUp() {
        // Mock implementation for now
        errorMessage = nil
        guard !fullName.isEmpty, !signUpEmail.isEmpty, !signUpPassword.isEmpty else {
            errorMessage = "Please fill all required fields."
            return
        }
        // Simulate success immediately signing user in
        isAuthenticated = true
    }
}
