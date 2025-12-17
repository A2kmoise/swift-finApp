import Vapor

struct CreateTransactionDTO: Content {
    let category: String
    let amount: Double
    let date: Date
}

struct TransactionResponseDTO: Content {
    let id: UUID?
    let type: String
    let category: String
    let amount: Double
    let date: Date
}

struct BalanceResponseDTO: Content {
    let balance: Double
}
