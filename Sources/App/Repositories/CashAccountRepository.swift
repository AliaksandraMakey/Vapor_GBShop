import Vapor
import Fluent

protocol CashAccountRepository: Repository {
    func create(_ basket: CashAccount) -> EventLoopFuture<Void>
    func findByUserId(userId: UUID) -> EventLoopFuture<CashAccount?>
    func update(_ cashAccount: CashAccount) -> EventLoopFuture<Void>
    func set<Field>(_ field: KeyPath<CashAccount, Field>, to value: Field.Value, for cashAccountID: UUID) -> EventLoopFuture<Void> where Field: QueryableProperty, Field.Model == CashAccount
}

struct DatabaseCashAccountRepository: CashAccountRepository, DatabaseRepository {
    let database: Database
    
    func create(_ cashAccount: CashAccount) -> EventLoopFuture<Void> {
        return cashAccount.create(on: database)
    }
    
    func findByUserId(userId: UUID) -> EventLoopFuture<CashAccount?> {
        return CashAccount.query(on: database)
            .filter(\.$userId == userId)
            .first()
    }
    
    func update(_ cashAccount: CashAccount) -> EventLoopFuture<Void> {
        return cashAccount.update(on: database)
    }
    func set<Field>(_ field: KeyPath<CashAccount, Field>, to value: Field.Value, for cashAccountID: UUID) -> EventLoopFuture<Void> where Field: QueryableProperty, Field.Model == CashAccount {
        return CashAccount.query(on: database)
            .filter(\.$id == cashAccountID)
            .set(field, to: value)
            .update()
    }

}
extension Application.Repositories {
    var cashAccount: CashAccountRepository {
        guard let storage = storage.makeCashAccountRepository else {
            fatalError("BasketRepository not configured, use: app.basketRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (CashAccountRepository)) {
        storage.makeCashAccountRepository = make
    }
}
