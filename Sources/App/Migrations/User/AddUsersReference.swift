

import Foundation
import Fluent

struct AddUsersReference: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .field("basket_id", .uuid, .references("baskets", "id"))
            .field("cash_account_id", .uuid, .references("cash_accounts", "id"))
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.eventLoop.makeSucceededFuture(())
    }
}
