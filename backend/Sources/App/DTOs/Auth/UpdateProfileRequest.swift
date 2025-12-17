import Vapor

struct UpdateProfileRequest: Content {
    let fullName: String?
    let password: String?
}
