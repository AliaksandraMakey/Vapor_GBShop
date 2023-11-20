
import Vapor
import Fluent

struct CashAccountController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("cash-account") { cashAccount in
            
            cashAccount.group(UserAuthenticator()) { cashAccount in
                cashAccount.post("add-cash", use: addCashToAccount)
                cashAccount.put("update-cash", use: updateCashAccount)
                cashAccount.get("all-balance", use: getAllMoneyInCashAccount)
            }
        }
    }
    private func addCashToAccount(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.getPayload()
        let changeCashRequest = try req.content.decode(BalanceInCashAccount.self)
        return req.cashAccounts
            .findByUserId(userId: payload.userID)
            .flatMap { cashAccount in
                guard let cashAccount = cashAccount else {
                    return req.eventLoop
                        .makeFailedFuture(CashAccountError.cashAccountNotFound)
                }
                if cashAccount.balance <= 0.0 {
                    cashAccount.balance = changeCashRequest.balance
                } else {
                    cashAccount.balance = (cashAccount.balance + changeCashRequest.balance)
                }
                return req.cashAccounts
                    .update(cashAccount)
                    .map { _ in
                        return .ok
                    }
            }
    }
    private func updateCashAccount(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.getPayload()
        let changeCashRequest = try req.content.decode(BalanceInCashAccount.self)
        
        return req.cashAccounts
            .findByUserId(userId: payload.userID)
            .flatMap { cashAccount in
                guard let cashAccount = cashAccount else {
                    return req.eventLoop
                        .makeFailedFuture(CashAccountError.cashAccountNotFound)
                }
                if changeCashRequest.balance > cashAccount.balance {
                    return req.eventLoop
                        .makeFailedFuture(CashAccountError.noMoneyInAccount)
                }
                let newCashValue = (cashAccount.balance - changeCashRequest.balance)
                cashAccount.balance = newCashValue
                return req.cashAccounts
                    .update(cashAccount)
                    .transform(to: .ok)
            }
    }
    private func getAllMoneyInCashAccount(_ req: Request) throws -> EventLoopFuture<CashAccountDTO> {
        let payload = try req.getPayload()
        
        return req.cashAccounts
            .findByUserId(userId: payload.userID)
            .flatMap { cashAccount in
                
                let cashAccountDTO = cashAccount.map { CashAccountDTO(from: $0) }
                if let cashAccountDTO = cashAccountDTO {
                    return req.eventLoop.makeSucceededFuture(cashAccountDTO)
                } else {
                    return req.eventLoop.makeFailedFuture(CashAccountError.invalidIDCashAccount)
                }
            }
    }
}
