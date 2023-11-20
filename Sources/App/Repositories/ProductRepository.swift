import Vapor
import Fluent

protocol ProductRepository: Repository {
    func create(_ product: Product) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func findAll() -> EventLoopFuture<[Product]>
    func find(id: UUID?) -> EventLoopFuture<Product?>
    func find(idNumber: String) -> EventLoopFuture<Product?>
    func findAllByIDNumber(idNumbers: [String]) -> EventLoopFuture<[Product?]>
    func set<Field>(_ field: KeyPath<Product, Field>,
                    to value: Field.Value, for productID: UUID) -> EventLoopFuture<Void> where Field: QueryableProperty, Field.Model == Product
    func count() -> EventLoopFuture<Int>
}

struct DatabaseProductRepository: ProductRepository, DatabaseRepository {
    let database: Database
    
    func create(_ product: Product) -> EventLoopFuture<Void> {
        return product.create(on: database)
    }
    
    func delete(id: UUID) -> EventLoopFuture<Void> {
        return Product.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func findAll() -> EventLoopFuture<[Product]> {
        return Product.query(on: database).all()
    }
    
    func find(id: UUID?) -> EventLoopFuture<Product?> {
        return Product.find(id, on: database)
    }
    
    func find(idNumber: String) -> EventLoopFuture<Product?> {
        return Product.query(on: database)
            .filter(\.$idNumber == idNumber)
            .first()
    }
    func findAllByIDNumber(idNumbers: [String]) -> EventLoopFuture<[Product?]> {
        return Product.query(on: database)
            .filter(\.$idNumber ~~ idNumbers)
            .all()
            .map { products in
                return products.map { $0 }
            }
    }

    func set<Field>(_ field: KeyPath<Product, Field>, to value: Field.Value, for productID: UUID) -> EventLoopFuture<Void>
        where Field: QueryableProperty, Field.Model == Product
    {
        return Product.query(on: database)
            .filter(\.$id == productID)
            .set(field, to: value)
            .update()
    }
    
    func count() -> EventLoopFuture<Int> {
        return Product.query(on: database).count()
    }
}

extension Application.Repositories {
    var products: ProductRepository {
        guard let storage = storage.makeProductRepository else {
            fatalError("ProductRepository not configured, use: app.productRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (ProductRepository)) {
        storage.makeProductRepository = make
    }
}



