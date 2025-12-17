import Vapor

struct RegisterRequest: Content {
    let fullName: String
    let email: String
    let phoneNumber: String
    let password: String
}
