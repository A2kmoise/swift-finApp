import Vapor

enum AuthRoutes {
    static func boot(_ app: Application) throws {
        let controller = AuthController()
        let group = app.grouped("auth")
        group.post("register", use: controller.register)
        group.post("login", use: controller.login)

        let protected = group.grouped(JWTAuthMiddleware())
        protected.put("profile", use: controller.updateProfile)
    }
}
