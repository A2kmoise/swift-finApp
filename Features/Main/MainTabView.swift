import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            BudgetsView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Budgets")
                }

            TransactionsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Transactions")
                }
        }
        .tint(FintrackTheme.primaryGreen)
    }
}

#Preview {
    MainTabView()
}
