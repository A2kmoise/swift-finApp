import Vapor
import JWT

struct JWTAuthMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // Extract token from "Authorization: Bearer <token>" header
        guard let bearer = request.headers.bearerAuthorization else {
            throw Abort(.unauthorized, reason: "Missing bearer token")
        }

        do {
            let payload = try request.jwt.verify(bearer.token, as: AuthPayload.self)
            guard let userID = UUID(uuidString: payload.subject.value) else {
                throw Abort(.unauthorized, reason: "Invalid token subject")
            }

            guard let user = try await User.find(userID, on: request.db) else {
                throw Abort(.unauthorized, reason: "User not found")
            }

            // Attach user to request for later use
            request.storage[UserKey.self] = user
            return try await next.respond(to: request)
        } catch {
            throw Abort(.unauthorized, reason: "Invalid or expired token")
        }
    }
}

private struct UserKey: StorageKey {
    typealias Value = User
}

extension Request {
    var authUser: User {
        get throws {
            guard let user = storage[UserKey.self] else {
                throw Abort(.unauthorized, reason: "No authenticated user in request")
            }
            return user
        }
    }
}
