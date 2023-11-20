import Vapor

func migrations(_ app: Application) throws {
    // Initial Migrations
    app.migrations.add(CreateUser())
    app.migrations.add(CreateRefreshToken())
    app.migrations.add(CreateEmailToken())
    app.migrations.add(CreatePasswordToken())
  
    app.migrations.add(CreateProduct())
    app.migrations.add(CreateCashAccount())
    app.migrations.add(CreateBasket())
    app.migrations.add(AddUsersReference())
    app.migrations.add(CreateBasketProduct())
}
