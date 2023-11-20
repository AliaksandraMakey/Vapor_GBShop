
import Vapor

enum ProductError: AppError {
    case productAlreadyExists
    case invalidIDNumberProduct
    case productNotFound
}

extension ProductError: AbortError {
    var status: HTTPResponseStatus {
        switch self {
        case .productAlreadyExists:
            return .badRequest
        case .invalidIDNumberProduct:
            return .noContent
        case .productNotFound:
            return .notFound
        }
    }
    
    var reason: String {
        switch self {
        case .productAlreadyExists:
            return "A product with that id number already exists"
        case .productNotFound:
            return "Product was not found"
        case .invalidIDNumberProduct:
            return "Invalid id number of product"
        }
    }
    
    var identifier: String {
        switch self {
        case .productAlreadyExists:
            return "product_already_exists"
        case .productNotFound:
            return "product_not_found"
        case .invalidIDNumberProduct:
            return "invalid_ID_number_product"
        }
    }
}
