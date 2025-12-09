import Foundation

struct RequestFavoriteModel: Codable {
    var lists: [RequestBasketModel]
}

struct RequestBasketModel: Codable {
    var list: [ItemBasketModel]
    var purchaiseList: [BasketModel]
}

struct ItemBasketModel: Codable {
    var id: Int
    var title: String
    var price: String
    var image: String
    var qty: Int
}

struct BasketModel: Codable {
    var id: Int
    var qty: Int
}
