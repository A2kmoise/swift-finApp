import SwiftUI

struct OnboardingPageInfo: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let showsDot: Bool
}

struct OnboardingFlowView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentIndex: Int = 0

    private let pages: [OnboardingPageInfo] = [
        OnboardingPageInfo(
            title: "Take Control of Your Finances",
            subtitle: "Welcome to Fintrack, your personal financial assistant. Track your expenses, set budgets, and stay in control every day.",
            showsDot: false
        ),
        OnboardingPageInfo(
            title: "Budget Smarter",
            subtitle: "Set your monthly budget, track expenses, and grow more mindful about your money.",
            showsDot: true
        ),
        OnboardingPageInfo(
            title: "Streamline Your Finances",
            subtitle: "Link your bank accounts, cards, and wallets to have a holistic view of your financial life in one place.",
            showsDot: true
        )
    ]

    var body: some View {
        ZStack {
            FintrackTheme.background.ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 16) {
                    Text("fintrack")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(FintrackTheme.primaryGreen)

                    if pages[currentIndex].showsDot {
                        Circle()
                            .fill(LinearGradient(
                                colors: [FintrackTheme.primaryGreen, .orange],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .frame(width: 96, height: 96)
                            .padding(.top, 24)
                    }

                    Text(pages[currentIndex].title)
                        .fintrackTitleStyle()
                        .multilineTextAlignment(.center)
                        .padding(.top, pages[currentIndex].showsDot ? 32 : 48)

                    Text(pages[currentIndex].subtitle)
                        .fintrackSubtitleStyle()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                VStack(spacing: 12) {
                    Button(action: primaryAction) {
                        Text(primaryButtonTitle)
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(FintrackTheme.primaryGreen)
                            .cornerRadius(12)
                    }

                    Button(action: { hasCompletedOnboarding = true }) {
                        Text("Skip")
                            .font(.subheadline)
                            .foregroundColor(FintrackTheme.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }

    private var primaryButtonTitle: String {
        if currentIndex < pages.count - 1 {
            return "Next"
        } else {
            return "Get Started"
        }
    }

    private func primaryAction() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
        } else {
            hasCompletedOnboarding = true
        }
    }
}

#Preview {
    OnboardingFlowView(hasCompletedOnboarding: .constant(false))
}
