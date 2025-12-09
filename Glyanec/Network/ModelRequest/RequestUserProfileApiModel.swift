import Foundation

struct RequestUserProfileApiModel: Codable, Equatable {
    let nickname: String
    let uniqueID: String
    let signature: String
    let birthday: String
    let gender: String
    
}
