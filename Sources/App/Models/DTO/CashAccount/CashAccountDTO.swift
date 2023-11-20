import Vapor

struct CashAccountDTO: Content {
    let id: UUID?
    let balance: Double
  
    
    init(id: UUID? = nil, balance: Double) {
        self.id = id
        self.balance = balance
    }
    
    init(from cashAccount: CashAccount) {
        self.init(id: cashAccount.id,
                  balance: cashAccount.balance)
    }
}

