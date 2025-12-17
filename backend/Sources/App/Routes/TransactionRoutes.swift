import Vapor

enum TransactionRoutes {
    static func boot(_ app: Application) throws {
        let controller = TransactionController()
        let protected = app.grouped("transactions").grouped(JWTAuthMiddleware())

        protected.post("income", use: controller.createIncome)
        protected.post("expense", use: controller.createExpense)
        protected.get(use: controller.listTransactions)

        // Balance endpoint on its own path but still logically under transactions
        let balanceGroup = app.grouped(JWTAuthMiddleware())
        balanceGroup.get("balance", use: controller.getBalance)
    }
}
