import Vapor
import Fluent

final class Basket: Model, Content {
    static let schema = "baskets"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_id")
    var userId: UUID

    init() { }

    init(userId: UUID) {
        self.userId = userId
    }
}
