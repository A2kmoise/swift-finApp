import Vapor
import Fluent

enum BudgetStatus: String, Codable, Content {
    case good
    case within
    case problem
}

final class Budget: Model, Content {
    static let schema = "budgets"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "name")
    var name: String

    @Field(key: "allocated_amount")
    var allocatedAmount: Double

    @Field(key: "category")
    var category: String

    @Field(key: "status")
    var status: BudgetStatus

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, userID: UUID, name: String, allocatedAmount: Double, category: String, status: BudgetStatus) {
        self.id = id
        self.$user.id = userID
        self.name = name
        self.allocatedAmount = allocatedAmount
        self.category = category
        self.status = status
    }
}
