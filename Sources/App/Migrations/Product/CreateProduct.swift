import Fluent

struct CreateProduct: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("products")
            .id()
            .field("id_number", .string, .required)
            .field("name", .string, .required)
            .field("status", .string, .required)
            .field("rating", .int, .required)
            .field("price", .double, .required)
            .field("image", .string, .required)
            .field("short_description", .string, .required)
            .field("description", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("products").delete()
    }
}


