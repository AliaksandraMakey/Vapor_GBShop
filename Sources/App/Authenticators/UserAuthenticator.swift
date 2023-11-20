import Vapor
import JWT

struct UserAuthenticator: JWTAuthenticator {
    typealias Payload = App.Payload
    
    func authenticate(jwt: Payload, for request: Request) -> EventLoopFuture<Void> {
        return request.refreshTokens.existByUserID(jwt.userID).flatMapThrowing { tokenExists in
                if tokenExists {
                    request.auth.login(jwt)
                } else {
                    throw AuthenticationError.accessTokenNotFound
                }
            }
            .transform(to: ())
    }
}
