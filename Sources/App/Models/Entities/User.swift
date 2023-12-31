import Vapor
import Fluent

final class User: Model, Authenticatable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "full_name")
    var fullName: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "is_admin")
    var isAdmin: Bool
    
    @Field(key: "gender")
    var gender: String
    
    @Field(key: "is_email_verified")
    var isEmailVerified: Bool
    
    @Field(key: "basket_id")
    var basketId: UUID?
    
    @Field(key: "cash_account_id")
    var cashAccountId: UUID?
    
    init() {}
    
    init(
        id: UUID? = nil,
        fullName: String,
        email: String,
        passwordHash: String,
        isAdmin: Bool = false,
        gender: String,
        isEmailVerified: Bool = false
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.passwordHash = passwordHash
        self.isAdmin = isAdmin
        self.gender = gender
        self.isEmailVerified = isEmailVerified
    }
    
}
