
import Vapor

struct UpdateProductRequest: Content {
    let id: UUID?
    let idNumber: String
    let name: String
    let status: String
    let rating: Int
    let price: Double
    let image: String
    let shortDescription: String
    let description: String
}
