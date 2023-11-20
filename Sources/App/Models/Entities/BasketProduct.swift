import Vapor
import Fluent

final class BasketProduct: Model {
    static let schema = "basket_product"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "basket_id")
    var basketId: UUID
    
    @Field(key: "product_id")
    var productId: UUID
    
    @Field(key: "quantity")
    var quantity: Int
    
    init() { }
    
    
    init(basketID: UUID, productID: UUID, quantity: Int) {
        self.basketId = basketID
        self.productId = productID
        self.quantity = quantity
    }
}
