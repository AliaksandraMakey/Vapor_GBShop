import Vapor

struct BasketDTO: Content {
    var id: UUID?
    var userId: UUID
    var products: [ProductDTO]
    
    init(basket: Basket, products: [ProductDTO]) {
        self.id = basket.id
        self.products = products
        self.userId = basket.userId
    }
}

