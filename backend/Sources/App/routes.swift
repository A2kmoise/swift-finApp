import Vapor

func routes(_ app: Application) throws {
    try AuthRoutes.boot(app)
    try TransactionRoutes.boot(app)
    try BudgetRoutes.boot(app)
    try AIRoutes.boot(app)
}
