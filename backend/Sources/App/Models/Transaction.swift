import Vapor
import Fluent

enum TransactionType: String, Codable {
    case income
    case expense
}

final class Transaction: Model, Content {
    static let schema = "transactions"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "type")
    var type: TransactionType

    @Field(key: "category")
    var category: String

    @Field(key: "amount")
    var amount: Double

    @Field(key: "date")
    var date: Date

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, userID: UUID, type: TransactionType, category: String, amount: Double, date: Date) {
        self.id = id
        self.$user.id = userID
        self.type = type
        self.category = category
        self.amount = amount
        self.date = date
    }
}
