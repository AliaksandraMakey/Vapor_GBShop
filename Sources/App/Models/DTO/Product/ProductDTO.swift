import Vapor

struct ProductDTO: Content {
    let id: UUID?
    let idNumber: String
    let name: String
    let status: String
    let rating: Int
    let price: Double
    let image: String
    let shortDescription: String
    let description: String
    
    init(id: UUID? = nil, idNumber: String, name: String,
         status: String, rating: Int, price: Double,
         image: String, shortDescription: String, description: String) {
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
    
    init(from product: Product) {
        self.init(id: product.id, 
                  idNumber: product.idNumber,
                  name: product.name,
                  status: product.status,
                  rating: product.rating,
                  price: product.price,
                  image: product.image,
                  shortDescription: product.shortDescription,
                  description: product.description)
    }
}

