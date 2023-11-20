import Vapor

extension Request {
    // MARK: Repositories
    var users: UserRepository { application.repositories.users.for(self) }
    var baskets: BasketRepository { application.repositories.baskets.for(self) }
    var cashAccounts: CashAccountRepository { application.repositories.cashAccount.for(self) }
    
    var basketProducts: BasketProductRepository { application.repositories.basketProducts.for(self) }
    var products: ProductRepository { application.repositories.products.for(self) }
    
    var refreshTokens: RefreshTokenRepository { application.repositories.refreshTokens.for(self) }
    var emailTokens: EmailTokenRepository { application.repositories.emailTokens.for(self) }
    var passwordTokens: PasswordTokenRepository { application.repositories.passwordTokens.for(self) }
    
//    var email: EmailVerifier { application.emailVerifiers.verifier.for(self) }
}
