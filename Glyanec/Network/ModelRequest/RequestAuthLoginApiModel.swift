import Foundation

struct RequestAuthLoginModel: Codable {
    let phone: String
    let password: String
}

struct RequestSignUpModel: Codable {
    let phone: String
    let mobile: String
}
