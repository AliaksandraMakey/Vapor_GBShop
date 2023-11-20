import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.group("api") { api in
        // Authentication
        try! api.register(collection: AuthenticationController())
        // User
        try! api.register(collection: UserController())
        // Product
        try! api.register(collection: ProductController())
        // Basket
        try! api.register(collection: BasketController())
        // CashAccount
        try! api.register(collection: CashAccountController())
    }
}
