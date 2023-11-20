import Vapor
import Fluent

final class Product: Model, Authenticatable {
    static let schema = "products"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "id_number")
    var idNumber: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "status")
    var status: String
    
    @Field(key: "rating")
    var rating: Int
    
    @Field(key: "price")
    var price: Double
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "short_description")
    var shortDescription: String
    
    @Field(key: "description")
    var description: String

    init() {}
    
    init(
        id: UUID? = nil,
        idNumber: String,
        name: String,
        status: String,
        rating: Int,
        price: Double,
        image: String,
        shortDescription: String,
        description: String
    ) {
        self.id = id
        self.idNumber = idNumber
        self.name = name
        self.status = status
        self.rating = rating
        self.price = price
        self.image = image
        self.shortDescription = shortDescription
        self.description = description
    }
}
