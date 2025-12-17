import Vapor
import Fluent
import JWT

struct AuthPayload: JWTPayload {
    var subject: SubjectClaim
    var expiration: ExpirationClaim

    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}

protocol AuthServiceProtocol {
    func register(_ req: Request, data: RegisterRequest) async throws -> HTTPStatus
    func login(_ req: Request, data: LoginRequest) async throws -> String
    func updateProfile(_ req: Request, data: UpdateProfileRequest) async throws -> HTTPStatus
}

struct AuthService: AuthServiceProtocol {
    func register(_ req: Request, data: RegisterRequest) async throws -> HTTPStatus {
        let existing = try await User.query(on: req.db)
            .filter(\.$email == data.email.lowercased())
            .first()
        if existing != nil {
            throw Abort(.badRequest, reason: "Email is already registered")
        }

        let hash = try Bcrypt.hash(data.password)
        let user = User(
            fullName: data.fullName,
            email: data.email.lowercased(),
            phoneNumber: data.phoneNumber,
            passwordHash: hash
        )
        try await user.save(on: req.db)
        return .created
    }

    func login(_ req: Request, data: LoginRequest) async throws -> String {
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == data.email.lowercased())
            .first() else {
            throw Abort(.unauthorized, reason: "Invalid email or password")
        }

        let isValid = try Bcrypt.verify(data.password, created: user.passwordHash)
        guard isValid else {
            throw Abort(.unauthorized, reason: "Invalid email or password")
        }

        let expiration = ExpirationClaim(value: .init(timeIntervalSinceNow: 60 * 60 * 24))
        let payload = AuthPayload(subject: .init(value: user.requireID().uuidString), expiration: expiration)
        let token = try req.jwt.sign(payload)
        return token
    }

    func updateProfile(_ req: Request, data: UpdateProfileRequest) async throws -> HTTPStatus {
        let user = try req.authUser

        if let fullName = data.fullName {
            user.fullName = fullName
        }

        if let password = data.password {
            let hash = try Bcrypt.hash(password)
            user.passwordHash = hash
        }

        try await user.save(on: req.db)
        return .ok
    }
}
