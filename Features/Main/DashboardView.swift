import SwiftUI

struct DashboardView: View {
    private let budget = SampleData.budget
    private let transactions = SampleData.transactions
    @State private var selectedRange: TimeRange = .monthly

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    balanceCard
                    timeframeSelector
                    chartCard
                    quickActionsRow
                    quickStatsRow
                    spendingSummaryCard
                    shortcutsRow
                    recentTransactionsCard
                }
                .padding(16)
            }
            .background(FintrackTheme.background.ignoresSafeArea())
            .navigationTitle("Overview")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Balance")
                .font(.subheadline)
                .foregroundColor(FintrackTheme.textSecondary)
            Text("$" + String(format: "%.2f", budget.totalBalance))
                .font(.largeTitle.bold())
                .foregroundColor(FintrackTheme.textPrimary)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Well done!")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(FintrackTheme.textPrimary)
                    Text("You are within your budget this month.")
                        .font(.caption)
                        .foregroundColor(FintrackTheme.textSecondary)
                }

                Spacer()

                VStack {
                    Text("Budget left")
                        .font(.caption)
                        .foregroundColor(FintrackTheme.textSecondary)
                    Text("$" + String(format: "%.0f", budget.monthlyBudget - budget.monthlyExpense))
                        .font(.headline)
                        .foregroundColor(FintrackTheme.primaryGreen)
                }
            }
        }
        .padding()
        .background(FintrackTheme.cardBackground)
        .cornerRadius(20)
    }

    private var shortcutsRow: some View {
        HStack(spacing: 12) {
            shortcut(title: "Stats", icon: "chart.bar.fill")
            shortcut(title: "Budgets", icon: "chart.pie.fill")
            shortcut(title: "Cards", icon: "creditcard.fill")
            shortcut(title: "Settings", icon: "gearshape.fill")
        }
    }

    private func shortcut(title: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(FintrackTheme.textPrimary)
                .frame(width: 32, height: 32)
                .background(FintrackTheme.cardBackground)
                .cornerRadius(10)
            Text(title)
                .font(.caption2)
                .foregroundColor(FintrackTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var quickStatsRow: some View {
        HStack(spacing: 12) {
            statCard(title: "Income", amount: budget.monthlyIncome, color: .green)
            statCard(title: "Expenses", amount: budget.monthlyExpense, color: .red)
            statCard(title: "Budget", amount: budget.monthlyBudget, color: FintrackTheme.primaryGreen)
        }
    }

    private var timeframeSelector: some View {
        HStack(spacing: 8) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button(action: { selectedRange = range }) {
                    Text(range.title)
                        .font(.caption)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(
                            selectedRange == range
                            ? FintrackTheme.primaryGreen.opacity(0.2)
                            : FintrackTheme.cardBackground
                        )
                        .foregroundColor(selectedRange == range ? FintrackTheme.primaryGreen : FintrackTheme.textSecondary)
                        .cornerRadius(12)
                }
            }
            Spacer()
        }
    }

    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Overview")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(FintrackTheme.textPrimary)
                Spacer()
                Text(selectedRange.subtitle)
                    .font(.caption)
                    .foregroundColor(FintrackTheme.textSecondary)
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
            .frame(height: 120)
        }
        .padding()
        .background(FintrackTheme.cardBackground)
        .cornerRadius(20)
    }

    private var quickActionsRow: some View {
        HStack(spacing: 12) {
            quickAction(icon: "plus.circle", title: "Add")
            quickAction(icon: "arrow.down.circle", title: "Income")
            quickAction(icon: "arrow.up.circle", title: "Expense")
            quickAction(icon: "ellipsis.circle", title: "More")
        }
    }

    private func quickAction(icon: String, title: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(FintrackTheme.primaryGreen)
                .frame(width: 40, height: 40)
                .background(FintrackTheme.cardBackground)
                .cornerRadius(12)
            Text(title)
                .font(.caption2)
                .foregroundColor(FintrackTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func statCard(title: String, amount: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(FintrackTheme.textSecondary)
            Text("$" + String(format: "%.0f", amount))
                .font(.headline)
                .foregroundColor(FintrackTheme.textPrimary)
            Spacer()
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 90)
        .background(FintrackTheme.cardBackground)
        .cornerRadius(16)
    }

    private var spendingSummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Monthly Budget")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(FintrackTheme.textPrimary)
                Spacer()
                Text("This month")
                    .font(.caption)
                    .foregroundColor(FintrackTheme.textSecondary)
            }

            // Simple bar-like representation
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(FintrackTheme.cardBackground)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(FintrackTheme.primaryGreen)
                        .frame(width: geo.size.width * CGFloat(budget.monthlyExpense / max(budget.monthlyBudget, 1)))
                }
            }
            .frame(height: 14)

            HStack {
                Text("Spent")
                    .font(.caption)
                    .foregroundColor(FintrackTheme.textSecondary)
                Text("$" + String(format: "%.0f", budget.monthlyExpense))
                    .font(.caption.weight(.semibold))
                    .foregroundColor(FintrackTheme.textPrimary)
                Spacer()
                Text("Budget")
                    .font(.caption)
                    .foregroundColor(FintrackTheme.textSecondary)
                Text("$" + String(format: "%.0f", budget.monthlyBudget))
                    .font(.caption.weight(.semibold))
                    .foregroundColor(FintrackTheme.textPrimary)
            }
        }
        .padding()
        .background(FintrackTheme.cardBackground)
        .cornerRadius(20)
    }

    private var recentTransactionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent activity")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(FintrackTheme.textPrimary)
                Spacer()
                Button(action: {}) {
                    Text("View all")
                        .font(.caption)
                        .foregroundColor(FintrackTheme.primaryGreen)
                }
            }

            ForEach(transactions.prefix(4)) { transaction in
                TransactionRowView(transaction: transaction)
            }
        }
        .padding()
        .background(FintrackTheme.cardBackground)
        .cornerRadius(20)
    }
}

struct TransactionRowView: View {
    let transaction: Transaction

    private var formattedAmount: String {
        let sign = transaction.type == .income ? "+" : "-"
        return sign + "$" + String(format: "%.2f", abs(transaction.amount))
    }

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(transaction.category.color)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.subheadline)
                    .foregroundColor(FintrackTheme.textPrimary)
                Text(transaction.category.title)
                    .font(.caption)
                    .foregroundColor(FintrackTheme.textSecondary)
            }

            Spacer()

            Text(formattedAmount)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
    }
}

#Preview {
    DashboardView()
}
