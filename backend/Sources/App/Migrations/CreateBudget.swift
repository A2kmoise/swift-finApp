import Fluent

struct CreateBudget: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("budgets")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("name", .string, .required)
            .field("allocated_amount", .double, .required)
            .field("category", .string, .required)
            .field("status", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("budgets").delete()
    }
}
