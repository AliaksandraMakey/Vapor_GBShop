import Vapor

extension Request {
    var random: RandomGenerator {
        self.application.random
    }
     func getPayload() throws -> Payload {
        return try self.auth.require(Payload.self)
    }
     func getProductByID() throws -> UUID {
        if let productID = self.parameters.get("productID", as: UUID.self) {
            return productID
        } else {
            throw ProductError.invalidIDNumberProduct
        }
    }
}
