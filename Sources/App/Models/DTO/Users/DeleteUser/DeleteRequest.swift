
import Vapor

struct DeleteRequest: Content {
    let id: UUID?
    let accessToken: String
    let refreshToken: String
}
