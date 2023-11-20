
import Vapor

enum CashAccountError: AppError {
    case noMoneyInAccount
    case invalidIDCashAccount
    case cashAccountNotFound
}

extension CashAccountError: AbortError {
    var status: HTTPResponseStatus {
        switch self {

        case .noMoneyInAccount:
            return .methodNotAllowed
        case .invalidIDCashAccount:
            return .badRequest
        case .cashAccountNotFound:
            return .notFound
        }
    }
    
    var reason: String {
        switch self {
        case .noMoneyInAccount:
            return "There is no balance in the account"
        case .invalidIDCashAccount:
            return "Invalid id number in cash account"
        case .cashAccountNotFound:
            return "There is not found cash account"
        }
    }
    
    var identifier: String {
        switch self {
        case .noMoneyInAccount:
            return "no_money_in_account"
        case .invalidIDCashAccount:
            return "invalid_ID_cash_account"
        case .cashAccountNotFound:
            return "not_found_cash_account"
        }
    }
}
