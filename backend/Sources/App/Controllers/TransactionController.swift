import Vapor

final class TransactionController {
    private let service: TransactionServiceProtocol

    init(service: TransactionServiceProtocol = TransactionService()) {
        self.service = service
    }

    func createIncome(_ req: Request) async throws -> TransactionResponseDTO {
        let dto = try req.content.decode(CreateTransactionDTO.self)
        let user = try req.authUser
        return try await service.createIncome(req, data: dto, user: user)
    }

    func createExpense(_ req: Request) async throws -> TransactionResponseDTO {
        let dto = try req.content.decode(CreateTransactionDTO.self)
        let user = try req.authUser
        return try await service.createExpense(req, data: dto, user: user)
    }

    func listTransactions(_ req: Request) async throws -> [TransactionResponseDTO] {
        let user = try req.authUser
        return try await service.listTransactions(req, user: user)
    }

    func getBalance(_ req: Request) async throws -> BalanceResponseDTO {
        let user = try req.authUser
        return try await service.getBalance(req, user: user)
    }
}
