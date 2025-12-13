import SwiftUI

struct AuthContainerView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var showSignUp: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                FintrackTheme.background.ignoresSafeArea()

                if authViewModel.isAuthenticated {
                    MainTabView()
                } else {
                    if showSignUp {
                        SignUpView(showSignUp: $showSignUp)
                    } else {
                        SignInView(showSignUp: $showSignUp)
                    }
                }
            }
        }
    }
}

#Preview {
    AuthContainerView()
        .environmentObject(AuthViewModel())
}
