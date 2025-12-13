import SwiftUI

struct TransactionsView: View {
    private let transactions = SampleData.transactions
    @State private var selectedFilter: TransactionFilter = .all

    var body: some View {
        NavigationStack {
            List {
                filterSegment

                ForEach(groupedTransactions.keys.sorted(by: >), id: \.self) { date in
                    Section(header: Text(date)
                        .font(.caption)
                        .foregroundColor(FintrackTheme.textSecondary)) {
                        ForEach(groupedTransactions[date] ?? []) { transaction in
                            TransactionRowView(transaction: transaction)
                                .listRowBackground(FintrackTheme.cardBackground)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(FintrackTheme.background.ignoresSafeArea())
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension TransactionsView {
    var filteredTransactions: [Transaction] {
        switch selectedFilter {
        case .all:
            return transactions
        case .spending:
            return transactions.filter { $0.type == .expense }
        case .income:
            return transactions.filter { $0.type == .income }
        }
    }

    var groupedTransactions: [String: [Transaction]] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        return Dictionary(grouping: filteredTransactions) { transaction in
            formatter.string(from: transaction.date)
        }
    }

    var filterSegment: some View {
        HStack(spacing: 8) {
            ForEach(TransactionFilter.allCases, id: \.self) { filter in
                Button(action: { selectedFilter = filter }) {
                    Text(filter.title)
                        .font(.caption)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(selectedFilter == filter ? FintrackTheme.primaryGreen : FintrackTheme.cardBackground)
                        .foregroundColor(selectedFilter == filter ? .black : FintrackTheme.textSecondary)
                        .cornerRadius(12)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

enum TransactionFilter: CaseIterable {
    case all
    case spending
    case income

    var title: String {
        switch self {
        case .all: return "All"
        case .spending: return "Spending"
        case .income: return "Income"
        }
    }
}

#Preview {
    TransactionsView()
}
