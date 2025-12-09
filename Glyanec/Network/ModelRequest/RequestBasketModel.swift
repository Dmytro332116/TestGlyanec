import Foundation

struct BasketRequestModel: Codable {
    var list: [BasketRequestItem]
}

struct BasketRequestItem: Codable {
    var id: String
    var qty: Int
}

struct ItemBasketModel: Codable {
    let id: String?
    let title: String?
    let price: Double?
    let image: String?
    let images: [String]?
    let qty: Int?

    var displayImage: String? { images?.first ?? image }
    var safeQty: Int { qty ?? 0 }
    var safePrice: Double { price ?? 0 }

    init(id: String?, title: String?, price: Double?, image: String?, images: [String]? = nil, qty: Int?) {
        self.id = id
        self.title = title
        self.price = price
        self.image = image
        self.images = images
        self.qty = qty
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)

        if let doublePrice = try container.decodeIfPresent(Double.self, forKey: .price) {
            price = doublePrice
        } else if let priceString = try container.decodeIfPresent(String.self, forKey: .price) {
            price = Double(priceString)
        } else {
            price = nil
        }

        if let decodedImages = try container.decodeIfPresent([String].self, forKey: .images) {
            images = decodedImages
        } else if let singleImage = try container.decodeIfPresent(String.self, forKey: .image) {
            images = [singleImage]
        } else {
            images = nil
        }

        image = try container.decodeIfPresent(String.self, forKey: .image)

        if let intQty = try container.decodeIfPresent(Int.self, forKey: .qty) {
            qty = intQty
        } else if let qtyString = try container.decodeIfPresent(String.self, forKey: .qty) {
            qty = Int(qtyString)
        } else {
            qty = nil
        }
    }
}
