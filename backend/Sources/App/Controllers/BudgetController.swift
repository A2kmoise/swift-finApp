import Vapor

final class BudgetController {
    private let service: BudgetServiceProtocol

    init(service: BudgetServiceProtocol = BudgetService()) {
        self.service = service
    }

    func createBudget(_ req: Request) async throws -> BudgetResponseDTO {
        let dto = try req.content.decode(CreateBudgetDTO.self)
        let user = try req.authUser
        return try await service.createBudget(req, data: dto, user: user)
    }

    func listBudgets(_ req: Request) async throws -> [BudgetResponseDTO] {
        let user = try req.authUser
        return try await service.listBudgets(req, user: user)
    }
}
