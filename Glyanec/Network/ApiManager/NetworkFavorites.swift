import Foundation
import PromiseKit
import Alamofire

class NetworkFavorites {

    static private var baseURL: String {
        return Glyanec.apiEndpoint + "favorite/api/v1.0/"
    }

    static private var listUrl: String {
        return baseURL + "list"
    }

    static private var addUrl: String {
        return baseURL + "add"
    }

    static private var removeUrl: String {
        return baseURL + "remove"
    }

    static func listFavorites() -> Promise<FavoriteListResponse> {
        return Promise<FavoriteListResponse> { resolver in
            NetworkSessionManager.shared
                .sessionManager
                .request(listUrl,
                         method: .get,
                         parameters: nil,
                         encoding: URLEncoding.default,
                         headers: nil)
                .validate()
                .responseJSON { response in
                    guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }

                    if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                        return resolver.reject(APIError(errorData: errorMessage))
                    }

                    do {
                        let list = try JSONDecoder().decode(FavoriteListResponse.self, from: data)
                        resolver.fulfill(list)
                    } catch {
                        print("Error: \(error)")
                        resolver.reject(NetworkError.nonResultError)
                    }
                }
        }
    }

    static func addFavorite(id: String) -> Promise<FavoriteToggleResponse> {
        return toggleFavorite(url: addUrl, id: id)
    }

    static func removeFavorite(id: String) -> Promise<FavoriteToggleResponse> {
        return toggleFavorite(url: removeUrl, id: id)
    }

    private static func toggleFavorite(url: String, id: String) -> Promise<FavoriteToggleResponse> {
        return Promise<FavoriteToggleResponse> { resolver in
            let parameters: Parameters = ["id": id]
            NetworkSessionManager.shared
                .sessionManager
                .request(url,
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default,
                         headers: nil)
                .validate()
                .responseJSON { response in
                    guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }

                    if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                        return resolver.reject(APIError(errorData: errorMessage))
                    }

                    do {
                        let result = try JSONDecoder().decode(FavoriteToggleResponse.self, from: data)
                        resolver.fulfill(result)
                    } catch {
                        print("Error: \(error)")
                        resolver.reject(NetworkError.nonResultError)
                    }
                }
        }
    }
}

struct FavoriteToggleResponse: Decodable {
    let status: Bool?
    let message: String?
}

struct FavoriteListResponse: Decodable {
    let products: [ResultProductModel]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var decodedProducts: [ResultProductModel] = []

        if let items = try container.decodeIfPresent([ResultProductModel].self, forKey: DynamicCodingKeys(stringValue: "products")) {
            decodedProducts = items
        } else if let items = try container.decodeIfPresent([ResultProductModel].self, forKey: DynamicCodingKeys(stringValue: "items")) {
            decodedProducts = items
        } else if let items = try container.decodeIfPresent([ResultProductModel].self, forKey: DynamicCodingKeys(stringValue: "list")) {
            decodedProducts = items
        }

        products = decodedProducts
    }
}

private struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
}
