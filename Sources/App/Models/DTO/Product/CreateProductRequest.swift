import Vapor

struct CreateProductRequest: Content {
    let idNumber: String
    let name: String
    let status: String
    let price: Double
    let rating: Int
    let image: String
    let shortDescription: String
    let description: String
}

extension Product {
    convenience init(from creater: CreateProductRequest, hash: String) throws {
        self.init(idNumber: creater.idNumber,
                  name: creater.name,
                  status: creater.status,
                  rating: creater.rating,
                  price: creater.price,
                  image: creater.image,
                  shortDescription: creater.shortDescription,
                  description: creater.description)
    }
}


