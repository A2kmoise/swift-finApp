import Vapor

final class AIController {
    private let service: AIServiceProtocol

    init(service: AIServiceProtocol = MockAIService()) {
        self.service = service
    }

    func chat(_ req: Request) async throws -> AIChatResponse {
        let dto = try req.content.decode(AIChatRequest.self)
        let user = try req.authUser
        let reply = try await service.sendMessage(req, message: dto.userMessage, user: user)
        return AIChatResponse(reply: reply)
    }
}
