import Foundation

public struct RequestForgotModel: Codable, Equatable {
    public let mail: String
}

public struct RequestVerifyModel: Codable, Equatable {
    public let mail: String
}

public struct RequestVerifyNewPhoneModel: Codable, Equatable {
    public let code: Int
}
