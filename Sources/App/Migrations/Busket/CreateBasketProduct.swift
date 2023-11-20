import Fluent

struct CreateBasketProduct: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("basket_product")
            .id()
            .field("basket_id", .uuid, .references("baskets", "id"))
            .field("product_id", .uuid, .references("products", "id"))
            .field("quantity", .int, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("basket_product").delete()
    }
}
