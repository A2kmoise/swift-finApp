import Vapor

enum BudgetRoutes {
    static func boot(_ app: Application) throws {
        let controller = BudgetController()
        let protected = app.grouped("budgets").grouped(JWTAuthMiddleware())

        protected.post(use: controller.createBudget)
        protected.get(use: controller.listBudgets)
    }
}
