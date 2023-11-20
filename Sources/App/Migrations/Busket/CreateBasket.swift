import Fluent

struct CreateBasket: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("baskets")
            .id()
            .field("user_id", .uuid, .references("users", "id")) 
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("baskets").delete()
    }
}
