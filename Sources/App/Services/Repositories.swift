import Vapor
import Fluent

protocol Repository: RequestService {}

protocol DatabaseRepository: Repository {
    var database: Database { get }
    init(database: Database)
}

extension DatabaseRepository {
    func `for`(_ req: Request) -> Self {
        return Self.init(database: req.db)
    }
}

extension Application {
    struct Repositories {
        struct Provider {
            static var database: Self {
                .init {
                    //User
                    $0.repositories.use { DatabaseUserRepository(database: $0.db) }
                    //Basket+cash
                    $0.repositories.use { DatabaseProductRepository(database: $0.db) }
                    $0.repositories.use { DatabaseBasketRepository(database: $0.db) }
                    $0.repositories.use { DatabaseBasketProductRepository(database: $0.db) }
                    $0.repositories.use { DatabaseCashAccountRepository(database: $0.db) }
                    //Auth
                    $0.repositories.use { DatabaseEmailTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabaseRefreshTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabasePasswordTokenRepository(database: $0.db) }
             
                }
            }
            
            let run: (Application) -> ()
        }
        
        final class Storage {
            //User
            var makeUserRepository: ((Application) -> UserRepository)?
            //Basket+cash
            var makeProductRepository: ((Application) -> ProductRepository)?
            var makeBasketRepository: ((Application) -> BasketRepository)?
            var makeBasketProductRepository: ((Application) -> BasketProductRepository)?
            var makeCashAccountRepository: ((Application) -> CashAccountRepository)?
            //Auth
            var makeEmailTokenRepository: ((Application) -> EmailTokenRepository)?
            var makeRefreshTokenRepository: ((Application) -> RefreshTokenRepository)?
            var makePasswordTokenRepository: ((Application) -> PasswordTokenRepository)?
         
            
            init() { }
        }
        
        struct Key: StorageKey {
            typealias Value = Storage
        }
        
        let app: Application
        
        func use(_ provider: Provider) {
            provider.run(app)
        }
        
        var storage: Storage {
            if app.storage[Key.self] == nil {
                app.storage[Key.self] = .init()
            }
            
            return app.storage[Key.self]!
        }
    }
    
    var repositories: Repositories {
        .init(app: self)
    }
}
