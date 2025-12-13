import SwiftUI

struct BudgetsView: View {
    @State private var showActive: Bool = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    toggleRow
                    donutChartCard
                    categoriesList
                }
                .padding(16)
            }
            .background(FintrackTheme.background.ignoresSafeArea())
            .navigationTitle("Budgets")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension BudgetsView {
    var toggleRow: some View {
        HStack(spacing: 8) {
            Button(action: { showActive = true }) {
                Text("Active")
                    .font(.caption)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .background(showActive ? FintrackTheme.primaryGreen : FintrackTheme.cardBackground)
                    .foregroundColor(showActive ? .black : FintrackTheme.textSecondary)
                    .cornerRadius(16)
            }
            Button(action: { showActive = false }) {
                Text("Closed")
                    .font(.caption)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .background(!showActive ? FintrackTheme.primaryGreen : FintrackTheme.cardBackground)
                    .foregroundColor(!showActive ? .black : FintrackTheme.textSecondary)
                    .cornerRadius(16)
            }
            Spacer()
        }
    }

    var donutChartCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Monthly budget")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(FintrackTheme.textPrimary)
                Spacer()
                Text("This month")
                    .font(.caption)
                    .foregroundColor(FintrackTheme.textSecondary)
            }

            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(FintrackTheme.cardBackground, lineWidth: 18)

                Circle()
                    .trim(from: 0, to: 0.65)
                    .stroke(AngularGradient(
                        gradient: Gradient(colors: [.orange, .red, FintrackTheme.primaryGreen]),
                        center: .center
                    ), style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 4) {
                    Text("$2,304.45")
                        .font(.headline)
                        .foregroundColor(FintrackTheme.textPrimary)
                    Text("of $2,500 budget")
                        .font(.caption)
                        .foregroundColor(FintrackTheme.textSecondary)
                }
            }
            .frame(height: 160)
        }
        .padding()
        .background(FintrackTheme.cardBackground)
        .cornerRadius(20)
    }

    var categoriesList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(FintrackTheme.textPrimary)

            ForEach(TransactionCategory.allCases, id: \.self) { category in
                HStack {
                    Circle()
                        .fill(category.color)
                        .frame(width: 24, height: 24)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(category.title)
                            .font(.subheadline)
                            .foregroundColor(FintrackTheme.textPrimary)
                        Text("Spending this month")
                            .font(.caption)
                            .foregroundColor(FintrackTheme.textSecondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("$" + String(format: "%.0f", Double.random(in: 40...500)))
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(FintrackTheme.textPrimary)
                        Text("45% of budget")
                            .font(.caption)
                            .foregroundColor(FintrackTheme.textSecondary)
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .padding()
        .background(FintrackTheme.cardBackground)
        .cornerRadius(20)
    }
}

#Preview {
    BudgetsView()
}
