import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("user") { user in
            
            user.group(UserAuthenticator()) { user in
                user.put("update", use: updateUser)
                user.delete("delete", use: deleteUser)
            }
        }
    }
    
    private func updateUser(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.auth.require(Payload.self)
        try UpdateUserRequest.validate(content: req)
        let updateUserRequest = try req.content.decode(UpdateUserRequest.self)
        req.users.set(\.$isAdmin, to: updateUserRequest.isAdmin, for: payload.userID)
        req.users.set(\.$fullName, to: updateUserRequest.fullName, for: payload.userID)
        req.users.set(\.$gender, to: updateUserRequest.gender, for: payload.userID)
        return req.eventLoop.makeSucceededFuture(.ok)
    }
    
    private func deleteUser(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.getPayload()
        
                return req.baskets.findByUserId(userId: payload.userID)
                    .flatMap { basket in
                        if let basket = basket {
                            req.users.delete(id:  payload.userID)
                            return req.baskets.delete(id: basket.id!)
                        } else {
                            return req.eventLoop.makeFailedFuture(BasketError.invalidIDBasket)
                        }
                  
                    }
                    .transform(to: .ok)
    }
}
