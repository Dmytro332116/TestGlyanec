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
    let characteristics: [ResultProductCharacteristicsModel]
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

