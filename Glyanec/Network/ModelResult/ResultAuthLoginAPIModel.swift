import Foundation

public struct ResultAuthLoginAPIModel: Codable, Equatable {
    public let code: Int
    public let data: String
    public let message: String
    public let requestId: String

    enum CodingKeys: String, CodingKey {
        case code, data, message, requestId = "request-id"
    }
}

public struct ResultAuthLoginModel: Decodable {
    let token_type: String?
    let token: String?
    let expires_at: String?
}

public struct ResultAuthSignUpModel: Decodable {
    let id: Int
    let email: String
    let first_name: String
    let birthday: String?
    let gender: String?
}
