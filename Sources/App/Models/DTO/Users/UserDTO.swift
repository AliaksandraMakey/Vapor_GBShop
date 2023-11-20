import Vapor

struct UserDTO: Content {
    let id: UUID?
    let fullName: String
    let email: String // login
    let isAdmin: Bool
    let gender: String
    let basketId: UUID?
    let cashAccountId: UUID?
    
    init(id: UUID? = nil, fullName: String, email: String,
         isAdmin: Bool, gender: String, basketId: UUID? = nil,
         cashAccountId: UUID? = nil) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.isAdmin = isAdmin
        self.gender = gender
        self.basketId = basketId
        self.cashAccountId = cashAccountId
    }
    
    init(from user: User) {
        self.init(id: user.id,
                  fullName: user.fullName,
                  email: user.email,
                  isAdmin: user.isAdmin,
                  gender: user.gender,
                  basketId: user.basketId,
                  cashAccountId: user.cashAccountId)
    }
}

