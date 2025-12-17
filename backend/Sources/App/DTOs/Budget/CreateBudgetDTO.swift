import Vapor

struct CreateBudgetDTO: Content {
    let budgetName: String
    let allocatedAmount: Double
    let relatedCategory: String
}

struct BudgetResponseDTO: Content {
    let id: UUID?
    let name: String
    let allocatedAmount: Double
    let category: String
    let status: String
}
