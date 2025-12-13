import SwiftUI

struct TransactionHistoryView: View {
    let title: String
    let transactions: [Transaction]

    private var grouped: [String: [Transaction]] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return Dictionary(grouping: transactions) { formatter.string(from: $0.date) }
    }

    var body: some View {
        List {
            ForEach(grouped.keys.sorted(by: >), id: \.self) { date in
                Section(header: Text(date)
                    .font(.caption)
                    .foregroundColor(FintrackTheme.textSecondary)) {
                    ForEach(grouped[date] ?? []) { transaction in
                        TransactionRowView(transaction: transaction)
                            .listRowBackground(FintrackTheme.cardBackground)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(FintrackTheme.background.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TransactionHistoryView(title: "Tue 6th June", transactions: SampleData.transactions)
    }
}
