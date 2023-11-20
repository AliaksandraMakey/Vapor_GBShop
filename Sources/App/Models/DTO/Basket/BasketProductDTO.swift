import Vapor

struct BasketProductDTO: Content {
    var product: ProductDTO
    var quantity: Int
    
    init(product: ProductDTO, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
}
