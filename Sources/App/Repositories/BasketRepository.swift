import Vapor
import Fluent

protocol BasketRepository: Repository {
    func create(_ basket: Basket) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func findByUserId(userId: UUID) -> EventLoopFuture<Basket?>
    func set<Field>(_ field: KeyPath<Basket, Field>, to value: Field.Value, for basketID: UUID) -> EventLoopFuture<Void> where Field: QueryableProperty, Field.Model == Basket
}

struct DatabaseBasketRepository: BasketRepository, DatabaseRepository {
    let database: Database
    
    func create(_ basket: Basket) -> EventLoopFuture<Void> {
        return basket.create(on: database)
    }
    
    func delete(id: UUID) -> EventLoopFuture<Void> {
        return Basket.query(on: database)
            .filter(\.$id == id)
            .delete()
    }

    func findByUserId(userId: UUID) -> EventLoopFuture<Basket?> {
        return Basket.query(on: database)
            .filter(\.$userId == userId)
            .first()
    }
    
    func set<Field>(_ field: KeyPath<Basket, Field>, to value: Field.Value, for basketID: UUID) -> EventLoopFuture<Void>
        where Field: QueryableProperty, Field.Model == Basket
    {
        return Basket.query(on: database)
            .filter(\.$id == basketID)
            .set(field, to: value)
            .update()
    }
    
}

extension Application.Repositories {
    var baskets: BasketRepository {
        guard let storage = storage.makeBasketRepository else {
            fatalError("BasketRepository not configured, use: app.basketRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (BasketRepository)) {
        storage.makeBasketRepository = make
    }
}
