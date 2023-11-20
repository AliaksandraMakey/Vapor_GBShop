import Vapor
import Fluent

final class CashAccount: Model, Content {
    static let schema = "cash_accounts"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_id")
    var userId: UUID
    
    @Field(key: "balance")
    var balance: Double
    
    init() { }

    init(userId: UUID, balance: Double) {
        self.userId = userId
        self.balance = balance
    }
}
