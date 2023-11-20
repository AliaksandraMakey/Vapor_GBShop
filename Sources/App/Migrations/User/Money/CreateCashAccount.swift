import Fluent

struct CreateCashAccount: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("cash_accounts")
            .id()
            .field("user_id", .uuid, .references("users", "id"))
            .field("balance", .double, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("cash_accounts").delete()
    }
}


