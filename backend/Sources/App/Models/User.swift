import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "full_name")
    var fullName: String

    @Field(key: "email")
    var email: String

    @Field(key: "phone_number")
    var phoneNumber: String

    @Field(key: "password_hash")
    var passwordHash: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Children(for: \.$user)
    var transactions: [Transaction]

    @Children(for: \.$user)
    var budgets: [Budget]

    init() {}

    init(id: UUID? = nil, fullName: String, email: String, phoneNumber: String, passwordHash: String) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.passwordHash = passwordHash
    }
}
