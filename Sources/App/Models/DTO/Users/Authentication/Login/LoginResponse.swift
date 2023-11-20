import Vapor

struct LoginResponse: Content {
    let user: UserDTO
    let accessToken: String
    let refreshToken: String
    var refreshTokenxpiresAt: Date = Date().addingTimeInterval(Constants.REFRESH_TOKEN_LIFETIME)
}
