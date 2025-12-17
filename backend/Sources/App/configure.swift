import Vapor
import Fluent
import FluentPostgresDriver
import JWT

enum App {}

extension App {
    static func configure(_ app: Application) throws {
        // Server configuration
        app.http.server.configuration.port = Environment.get("PORT").flatMap(Int.init) ?? 8080

        // Database configuration (PostgreSQL)
        let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
        let username = Environment.get("DATABASE_USERNAME") ?? "budget_user"
        let password = Environment.get("DATABASE_PASSWORD") ?? "password"
        let database = Environment.get("DATABASE_NAME") ?? "budget_db"
        let port = Environment.get("DATABASE_PORT").flatMap(Int.init) ?? PostgresConfiguration.ianaPortNumber

        app.databases.use(.postgres(
            hostname: hostname,
            port: port,
            username: username,
            password: password,
            database: database
        ), as: .psql)

        // JWT signer
        let jwtSecret = Environment.get("JWT_SECRET") ?? "CHANGE_ME_SUPER_SECRET_KEY"
        app.jwt.signers.use(.hs256(key: jwtSecret))

        // Migrations
        app.migrations.add(CreateUser())
        app.migrations.add(CreateTransaction())
        app.migrations.add(CreateBudget())

        // Middleware
        app.middleware.use(ErrorMiddleware.default(environment: app.environment))

        // Routes
        try routes(app)
    }
}
