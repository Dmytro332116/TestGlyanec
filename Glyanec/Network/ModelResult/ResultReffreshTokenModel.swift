import Foundation

struct RequestReffreshTokenModel: Codable {
    let token: String
}

struct ResultReffreshTokenModel: Codable {
    let accessToken: String
}
