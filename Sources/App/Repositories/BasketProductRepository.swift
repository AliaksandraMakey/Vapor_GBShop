import Vapor
import Fluent

protocol BasketProductRepository: Repository {
    func create(_ basketProduct: BasketProduct) -> EventLoopFuture<Void>
    func deleteByBasketAndProductId(basketId: UUID, productId: UUID) -> EventLoopFuture<Void>
    func deleteByBasket(basketId: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[BasketProduct]>
    func findByBasketAndProductId(basketId: UUID, productId: UUID) -> EventLoopFuture<BasketProduct?>
    func findAllByBasketId(_ basketId: UUID)  -> EventLoopFuture<[BasketProduct]>
    func update(_ basketProduct: BasketProduct) -> EventLoopFuture<Void>
}

struct DatabaseBasketProductRepository: BasketProductRepository, DatabaseRepository {
    let database: Database

    func create(_ basketProduct: BasketProduct) -> EventLoopFuture<Void> {
        return basketProduct.create(on: database)
    }
    func deleteByBasketAndProductId(basketId: UUID, productId: UUID) -> EventLoopFuture<Void> {
        return BasketProduct.query(on: database)
            .filter(\.$basketId == basketId)
            .filter(\.$productId == productId)
            .delete()
    }
    func deleteByBasket(basketId: UUID) -> EventLoopFuture<Void> {
        return BasketProduct.query(on: database)
            .filter(\.$basketId == basketId)
            .delete()
    }
    func all() -> EventLoopFuture<[BasketProduct]> {
        return BasketProduct.query(on: database).all()
    }
    func findByBasketAndProductId(basketId: UUID, productId: UUID) -> EventLoopFuture<BasketProduct?> {
        return BasketProduct.query(on: database)
            .filter(\.$basketId == basketId)
            .filter(\.$productId == productId)
            .first()
    }
    
    func findAllByBasketId(_ basketId: UUID)  -> EventLoopFuture<[BasketProduct]> {
        return BasketProduct.query(on: database)
            .filter(\.$basketId == basketId)
            .all()
    }

    func update(_ basketProduct: BasketProduct) -> EventLoopFuture<Void> {
        return basketProduct.update(on: database)
    }
}

extension Application.Repositories {
    var basketProducts: BasketProductRepository {
        guard let storage = storage.makeBasketProductRepository else {
            fatalError("BasketProductRepository not configured, use: app.basketProductRepository.use()")
        }

        return storage(app)
    }

    func use(_ make: @escaping (Application) -> (BasketProductRepository)) {
        storage.makeBasketProductRepository = make
    }
}
