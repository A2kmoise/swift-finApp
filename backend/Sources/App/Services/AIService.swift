import Vapor

protocol AIServiceProtocol {
    func sendMessage(_ req: Request, message: String, user: User) async throws -> String
}

/// Default mock implementation. In production you can swap this for a real provider.
struct MockAIService: AIServiceProtocol {
    func sendMessage(_ req: Request, message: String, user: User) async throws -> String {
        // In a real implementation, forward to an external AI API here.
        return "This is a mock AI response to: \(message)"
    }
}
