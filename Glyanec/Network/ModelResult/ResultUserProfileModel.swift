
import Foundation

// MARK: - ResultUserProfileModel
struct ResultUserProfileModel: Codable {
    let id: String?
    let nickname: String?
    let uniqueID: String?
    let signature: String?
    let longitude: String?
    let latitude: String?
    let avatar: String?
    let avatarThumb: String?
    let birthday: String?
    let gender: String?
    let isBlocked: Bool?
    let country: String?
    let city: String?
    let province: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case uniqueID
        case signature
        case longitude
        case latitude
        case avatar
        case avatarThumb
        case birthday
        case gender
        case isBlocked
        case country
        case city
        case province
    }

}


// MARK: - Location
struct Location: Codable {
    let longitude, latitude: Int?
}

// MARK: - ShareInfo
struct ShareInfo: Codable {
    let shareURL: String?
    let shareDesc, shareTitle: String?
    let shareImageURL: String?
    let shareTitleMyself, shareTitleOther: String?

    enum CodingKeys: String, CodingKey {
        case shareURL = "share_url"
        case shareDesc = "share_desc"
        case shareTitle = "share_title"
        case shareImageURL = "share_image_url"
        case shareTitleMyself = "share_title_myself"
        case shareTitleOther = "share_title_other"
    }
}

// MARK: - VideoList
struct VideoList: Codable {
    let id: String?
    let imageURL: String?
    let numberViews: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case numberViews = "number_views"
    }
}
