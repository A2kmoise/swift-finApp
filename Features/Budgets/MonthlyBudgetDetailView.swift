import SwiftUI

struct MonthlyBudgetDetailView: View {
    private let budget = SampleData.budget
    private let transactions = SampleData.transactions
    @State private var selectedRange: TimeRange = .monthly

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                topTransactionsCard
                spendingLimitCard
                timeRangeChartCard
            }
            .padding(16)
        }
        .background(FintrackTheme.background.ignoresSafeArea())
        .navigationTitle("Monthly Budget")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension MonthlyBudgetDetailView {
    var topTransactionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top transactions")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(FintrackTheme.textPrimary)

            ForEach(transactions.prefix(3)) { transaction in
                TransactionRowView(transaction: transaction)
            }
        }
        .padding()
        .background(FintrackTheme.cardBackground)
        .cornerRadius(20)
    }

    var spendingLimitCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly budget")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(FintrackTheme.textPrimary)

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(FintrackTheme.cardBackground, lineWidth: 14)

                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(FintrackTheme.primaryGreen, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 2) {
                        Text("70%")
                            .font(.headline)
                            .foregroundColor(FintrackTheme.textPrimary)
                        Text("used")
                            .font(.caption)
                            .foregroundColor(FintrackTheme.textSecondary)
                    }
                }
                .frame(width: 90, height: 90)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Monthly spending limit")
                        .font(.subheadline)
                        .foregroundColor(FintrackTheme.textPrimary)
                    Text("Spending: $" + String(format: "%.0f", budget.monthlyExpense))
                        .font(.caption)
                        .foregroundColor(FintrackTheme.textSecondary)
                    Text("Limit: $" + String(format: "%.0f", budget.monthlyBudget))
                        .font(.caption)
                        .foregroundColor(FintrackTheme.textSecondary)
                }

                Spacer()
            }
        }
        .padding()
        .background(FintrackTheme.cardBackground)
        .cornerRadius(20)
    }

    var timeRangeChartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Activity")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(FintrackTheme.textPrimary)
                Spacer()
                HStack(spacing: 8) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Button(action: { selectedRange = range }) {
                            Text(range.title)
                                .font(.caption2)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(selectedRange == range ? FintrackTheme.primaryGreen : FintrackTheme.cardBackground)
                                .foregroundColor(selectedRange == range ? .black : FintrackTheme.textSecondary)
                                .cornerRadius(10)
                        }
                    }
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(FintrackTheme.cardBackground)

                    HStack(alignment: .bottom, spacing: 6) {
                        ForEach(MockChartData.points(for: selectedRange)) { point in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(point.isHighlight ? FintrackTheme.primaryGreen : Color.orange)
                                .frame(width: (geo.size.width - 40) / CGFloat(MockChartData.points(for: selectedRange).count),
                                       height: geo.size.height * CGFloat(point.normalizedValue))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                }
            }
            .frame(height: 140)
        }
        .padding()
        .background(FintrackTheme.cardBackground)
        .cornerRadius(20)
    }
}

#Preview {
    NavigationStack {
        MonthlyBudgetDetailView()
    }
}
