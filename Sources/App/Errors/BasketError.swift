
import Vapor

enum BasketError: AppError {
    case invalidIDBasketProduct
    case invalidIDBasket
    case basketProductNotFound
}

extension BasketError: AbortError {
    var status: HTTPResponseStatus {
        switch self {
        case .invalidIDBasketProduct:
            return .notFound
        case .basketProductNotFound:
            return .notFound
        case .invalidIDBasket:
            return .notFound
        }
    }
    
    var reason: String {
        switch self {
        case .invalidIDBasketProduct:
            return "Invalid id number of basket product"
        case .basketProductNotFound:
            return "Basket product not found"
        case .invalidIDBasket:
            return "Invalid id number of basket"
        }
    }
    
    var identifier: String {
        switch self {
        case .invalidIDBasketProduct:
            return "invalid_ID_number_basket_product"
        case .basketProductNotFound:
            return "basket_product_not_found"
        case .invalidIDBasket:
            return "invalid_ID_number_basket"
        }
    }
}
