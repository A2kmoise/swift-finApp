import Vapor

final class AuthController {
    private let service: AuthServiceProtocol

    init(service: AuthServiceProtocol = AuthService()) {
        self.service = service
    }

    func register(_ req: Request) async throws -> HTTPStatus {
        let dto = try req.content.decode(RegisterRequest.self)
        return try await service.register(req, data: dto)
    }

    struct LoginResponse: Content {
        let token: String
    }

    func login(_ req: Request) async throws -> LoginResponse {
        let dto = try req.content.decode(LoginRequest.self)
        let token = try await service.login(req, data: dto)
        return LoginResponse(token: token)
    }

    func updateProfile(_ req: Request) async throws -> HTTPStatus {
        let dto = try req.content.decode(UpdateProfileRequest.self)
        return try await service.updateProfile(req, data: dto)
    }
}
