import Vapor
import Fluent

protocol TransactionServiceProtocol {
    func createIncome(_ req: Request, data: CreateTransactionDTO, user: User) async throws -> TransactionResponseDTO
    func createExpense(_ req: Request, data: CreateTransactionDTO, user: User) async throws -> TransactionResponseDTO
    func listTransactions(_ req: Request, user: User) async throws -> [TransactionResponseDTO]
    func getBalance(_ req: Request, user: User) async throws -> BalanceResponseDTO
}

struct TransactionService: TransactionServiceProtocol {
    func createIncome(_ req: Request, data: CreateTransactionDTO, user: User) async throws -> TransactionResponseDTO {
        let transaction = Transaction(
            userID: try user.requireID(),
            type: .income,
            category: data.category,
            amount: data.amount,
            date: data.date
        )
        try await transaction.save(on: req.db)
        return transaction.toDTO()
    }

    func createExpense(_ req: Request, data: CreateTransactionDTO, user: User) async throws -> TransactionResponseDTO {
        let transaction = Transaction(
            userID: try user.requireID(),
            type: .expense,
            category: data.category,
            amount: data.amount,
            date: data.date
        )
        try await transaction.save(on: req.db)
        return transaction.toDTO()
    }

    func listTransactions(_ req: Request, user: User) async throws -> [TransactionResponseDTO] {
        let userID = try user.requireID()
        let txs = try await Transaction.query(on: req.db)
            .filter(\.$user.$id == userID)
            .sort(\.$date, .descending)
            .all()
        return txs.map { $0.toDTO() }
    }

    func getBalance(_ req: Request, user: User) async throws -> BalanceResponseDTO {
        let userID = try user.requireID()
        let txs = try await Transaction.query(on: req.db)
            .filter(\.$user.$id == userID)
            .all()
        let income = txs.filter { $0.type == .income }.reduce(0.0) { $0 + $1.amount }
        let expenses = txs.filter { $0.type == .expense }.reduce(0.0) { $0 + $1.amount }
        return BalanceResponseDTO(balance: income - expenses)
    }
}

extension Transaction {
    func toDTO() -> TransactionResponseDTO {
        TransactionResponseDTO(
            id: self.id,
            type: self.type.rawValue,
            category: self.category,
            amount: self.amount,
            date: self.date
        )
    }
}
