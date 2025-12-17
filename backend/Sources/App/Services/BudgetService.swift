import Vapor
import Fluent

protocol BudgetServiceProtocol {
    func createBudget(_ req: Request, data: CreateBudgetDTO, user: User) async throws -> BudgetResponseDTO
    func listBudgets(_ req: Request, user: User) async throws -> [BudgetResponseDTO]
}

struct BudgetService: BudgetServiceProtocol {
    func createBudget(_ req: Request, data: CreateBudgetDTO, user: User) async throws -> BudgetResponseDTO {
        let userID = try user.requireID()

        // Calculate user's total income to validate allocatedAmount
        let txs = try await Transaction.query(on: req.db)
            .filter(\.$user.$id == userID)
            .all()
        let totalIncome = txs.filter { $0.type == .income }.reduce(0.0) { $0 + $1.amount }

        guard data.allocatedAmount <= totalIncome else {
            throw Abort(.badRequest, reason: "Allocated amount exceeds total income")
        }

        // Compute current spending for this category
        let categoryExpenses = txs.filter { $0.type == .expense && $0.category == data.relatedCategory }
        let totalExpenses = categoryExpenses.reduce(0.0) { $0 + $1.amount }

        let status = Self.computeStatus(spent: totalExpenses, allocated: data.allocatedAmount)

        let budget = Budget(
            userID: userID,
            name: data.budgetName,
            allocatedAmount: data.allocatedAmount,
            category: data.relatedCategory,
            status: status
        )
        try await budget.save(on: req.db)
        return budget.toDTO()
    }

    func listBudgets(_ req: Request, user: User) async throws -> [BudgetResponseDTO] {
        let userID = try user.requireID()
        let budgets = try await Budget.query(on: req.db)
            .filter(\.$user.$id == userID)
            .all()

        // For each budget, recompute status based on current expenses
        let txs = try await Transaction.query(on: req.db)
            .filter(\.$user.$id == userID)
            .all()

        var updatedBudgets: [BudgetResponseDTO] = []
        for budget in budgets {
            let expensesForCategory = txs.filter { $0.type == .expense && $0.category == budget.category }
            let spent = expensesForCategory.reduce(0.0) { $0 + $1.amount }
            let newStatus = Self.computeStatus(spent: spent, allocated: budget.allocatedAmount)
            if budget.status != newStatus {
                budget.status = newStatus
                try await budget.save(on: req.db)
            }
            updatedBudgets.append(budget.toDTO())
        }

        return updatedBudgets
    }

    private static func computeStatus(spent: Double, allocated: Double) -> BudgetStatus {
        guard allocated > 0 else { return .problem }
        let ratio = spent / allocated
        // Note: rules inverted from normal semantics but kept exactly as required
        if ratio < 0.5 { return .problem }
        if ratio <= 0.6 { return .within }
        return .good
    }
}

extension Budget {
    func toDTO() -> BudgetResponseDTO {
        BudgetResponseDTO(
            id: self.id,
            name: self.name,
            allocatedAmount: self.allocatedAmount,
            category: self.category,
            status: self.status.rawValue
        )
    }
}
