import SwiftUI

/// Root view you should use in your App entry:
/// WindowGroup { FintrackRootView() }
struct FintrackRootView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingFlowView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else {
                AuthContainerView()
                    .environmentObject(authViewModel)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    FintrackRootView()
}
