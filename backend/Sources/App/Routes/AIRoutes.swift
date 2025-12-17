import Vapor

enum AIRoutes {
    static func boot(_ app: Application) throws {
        let controller = AIController()
        let protected = app.grouped("ai").grouped(JWTAuthMiddleware())

        protected.post("chat", use: controller.chat)
    }
}
