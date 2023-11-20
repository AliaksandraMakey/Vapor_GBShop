import Vapor

struct UpdateUserRequest: Content {
    let fullName: String
    let isAdmin: Bool
    let gender: String
}

extension UpdateUserRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("fullName", as: String.self, is: .count(3...))
        validations.add("isAdmin", as: Bool.self, is: .in(true, false))
        validations.add("gender", as: String.self, is: .count(4...))
    }
}


