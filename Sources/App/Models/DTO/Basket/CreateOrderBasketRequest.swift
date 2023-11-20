
import Vapor

struct CreateOrderBasketRequest: Content {
    let productsInOrder: [ProductBasketRequest]
}

struct ProductBasketRequest: Content {
    let idNumber: String
    let quantity: Int
}
