import Foundation

// MARK: Categorys
struct ResultCategorysListModel: Decodable {
    let id: String?
    let name: String?
    let image: String?
    let count: String?
//    let depth: Double?
//    let parent: String?
}


// MARK: ProductsList
struct ResultProductsListModel: Decodable {
    let total: String?
    let pages: Double?
    let length: Double?
    let page: Double?
    let products: [ResultProductModel]

    init(total: String?, pages: Double?, length: Double?, page: Double?, products: [ResultProductModel]) {
        self.total = total
        self.pages = pages
        self.length = length
        self.page = page
        self.products = products
    }
}

// MARK: Product
struct ResultProductModel: Decodable {
    let id: String?
    let title: String?
    let vendor_code: String?
    let body: String?
    let price: Double?
    let price_old: Double?
    let count: Double?
    let categories: [ResultProductCategoriesModel]
    let images: [String]?
    let image: String?
    let characteristics: [ResultProductCharacteristicsModel]
    let is_favorite: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, vendor_code, body, price, price_old, count, categories, images, image, characteristics, is_favorite
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        vendor_code = try container.decodeIfPresent(String.self, forKey: .vendor_code)
        body = try container.decodeIfPresent(String.self, forKey: .body)
        let rawPrice = try container.decodeIfPresent(Double.self, forKey: .price)
        if rawPrice == nil {
            if let priceString = try container.decodeIfPresent(String.self, forKey: .price) {
                price = Double(priceString)
            } else {
                price = nil
            }
        } else {
            price = rawPrice
        }

        let rawOldPrice = try container.decodeIfPresent(Double.self, forKey: .price_old)
        if rawOldPrice == nil {
            if let priceString = try container.decodeIfPresent(String.self, forKey: .price_old) {
                price_old = Double(priceString)
            } else {
                price_old = nil
            }
        } else {
            price_old = rawOldPrice
        }

        if let countValue = try container.decodeIfPresent(Double.self, forKey: .count) {
            count = countValue
        } else if let countString = try container.decodeIfPresent(String.self, forKey: .count) {
            count = Double(countString)
        } else {
            count = nil
        }

        categories = (try container.decodeIfPresent([ResultProductCategoriesModel].self, forKey: .categories)) ?? []

        if let decodedImages = try container.decodeIfPresent([String].self, forKey: .images) {
            images = decodedImages
        } else if let singleImage = try container.decodeIfPresent(String.self, forKey: .image) {
            images = [singleImage]
        } else {
            images = nil
        }

        image = try container.decodeIfPresent(String.self, forKey: .image)
        characteristics = (try container.decodeIfPresent([ResultProductCharacteristicsModel].self, forKey: .characteristics)) ?? []
        is_favorite = try container.decodeIfPresent(Bool.self, forKey: .is_favorite)
    }
}

// MARK: ProductCharacteristics
struct ResultProductCategoriesModel: Decodable {
    let id: String?
    let name: String?
}

// MARK: ProductCharacteristics
struct ResultProductCharacteristicsModel: Decodable {
    let name: String?
    let value: String?
}

// MARK: ResultPurchaiseModel
struct ResultPurchaiseModel: Decodable {
    let status: Bool?
    let error: [ErrorPurchaiseModel]?
    let orderUrl: String?
}

// MARK: ErrorPurchaiseModel
struct ErrorPurchaiseModel: Decodable {
    let message: String?
    let code: Int?
}

// MARK: Basket
struct BasketResponseModel: Decodable {
    let status: Bool?
    let items: [ItemBasketModel]?
    let total: Double?
    let error: String?
    let orderUrl: String?

    enum CodingKeys: String, CodingKey {
        case status
        case items
        case total
        case error
        case orderUrl
        case list
        case products
        case basket
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Bool.self, forKey: .status)
        error = try container.decodeIfPresent(String.self, forKey: .error)
        if let decodedTotal = try container.decodeIfPresent(Double.self, forKey: .total) {
            total = decodedTotal
        } else if let totalString = try container.decodeIfPresent(String.self, forKey: .total) {
            total = Double(totalString)
        } else {
            total = nil
        }
        orderUrl = try container.decodeIfPresent(String.self, forKey: .orderUrl)

        if let decodedItems = try container.decodeIfPresent([ItemBasketModel].self, forKey: .items) {
            items = decodedItems
        } else if let decodedItems = try container.decodeIfPresent([ItemBasketModel].self, forKey: .list) {
            items = decodedItems
        } else if let decodedItems = try container.decodeIfPresent([ItemBasketModel].self, forKey: .products) {
            items = decodedItems
        } else if let decodedItems = try container.decodeIfPresent([ItemBasketModel].self, forKey: .basket) {
            items = decodedItems
        } else {
            items = nil
        }
    }
}

