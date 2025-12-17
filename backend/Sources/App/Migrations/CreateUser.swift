import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("full_name", .string, .required)
            .field("email", .string, .required)
            .unique(on: "email")
            .field("phone_number", .string, .required)
            .field("password_hash", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}
