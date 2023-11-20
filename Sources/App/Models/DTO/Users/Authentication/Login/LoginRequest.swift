import Vapor

struct LoginRequest: Content {
    let login: String
    let password: String
}

extension LoginRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("login", as: String.self, is:  !.empty)
        validations.add("password", as: String.self, is: !.empty)
    }
}
