import Foundation
import PromiseKit
import Alamofire

class NetworkPurchases {

static private var baseURL: String {
    return Glyanec.apiEndpoint + "basket/api/v1.0/"
}

static private var purchases: String {
    return baseURL + "add_items"
}

static private var remove: String {
    return baseURL + "remove_items"
}

static private var list: String {
    return baseURL + "list_items"
}

static private var clear: String {
    return baseURL + "clear"
}



static func listItems() -> Promise<BasketResponseModel> {
    return Promise<BasketResponseModel> { resolver in
        NetworkSessionManager.shared
            .sessionManager
            .request(list,
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
                    let basketModel = try JSONDecoder().decode(BasketResponseModel.self, from: data)
                    resolver.fulfill(basketModel)
                } catch {
                    print("Error: \(error)")
                    resolver.reject(NetworkError.nonResultError)
                }
            }
    }
}

static func addItems(_ items: [BasketRequestItem]) -> Promise<BasketResponseModel> {
    let request = BasketRequestModel(list: items)
    return sendBasketRequest(url: purchases, request: request)
}

static func removeItems(_ items: [BasketRequestItem]) -> Promise<BasketResponseModel> {
    let request = BasketRequestModel(list: items)
    return sendBasketRequest(url: remove, request: request)
}

static func clearItems() -> Promise<BasketResponseModel> {
    return Promise<BasketResponseModel> { resolver in
        NetworkSessionManager.shared
            .sessionManager
            .request(clear,
                     method: .post,
                     parameters: nil,
                     encoding: JSONEncoding.default,
                     headers: nil)
            .validate()
            .responseJSON { response in
                guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }

                if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                    return resolver.reject(APIError(errorData: errorMessage))
                }

                do {
                    let basketModel = try JSONDecoder().decode(BasketResponseModel.self, from: data)
                    resolver.fulfill(basketModel)
                } catch {
                    print("Error: \(error)")
                    resolver.reject(NetworkError.nonResultError)
                }
            }
    }
}

static func checkout(items: [BasketRequestItem]) -> Promise<ResultPurchaiseModel?> {
    return Promise<ResultPurchaiseModel?> { resolver in
        NetworkSessionManager.shared
            .sessionManager
            .request(purchases,
                     method: .post,
                     parameters: BasketRequestModel(list: items).dictionary,
                     encoding: JSONEncoding.default,
                     headers: nil)
            .validate()
            .responseJSON { response in
                guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }

                if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                    return resolver.reject(APIError(errorData: errorMessage))
                }

                do {
                    let purchaiseModel = try JSONDecoder().decode(ResultPurchaiseModel.self, from: data)
                    resolver.fulfill(purchaiseModel)
                } catch {
                    print("Error: \(error)")
                    resolver.reject(NetworkError.nonResultError)
                }
            }
    }
}

private static func sendBasketRequest(url: String, request: BasketRequestModel) -> Promise<BasketResponseModel> {
    return Promise<BasketResponseModel> { resolver in
        NetworkSessionManager.shared
            .sessionManager
            .request(url,
                     method: .post,
                     parameters: request.dictionary,
                     encoding: JSONEncoding.default,
                     headers: nil)
            .validate()
            .responseJSON { response in
                guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }

                if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                    return resolver.reject(APIError(errorData: errorMessage))
                }

                do {
                    let basketModel = try JSONDecoder().decode(BasketResponseModel.self, from: data)
                    resolver.fulfill(basketModel)
                } catch {
                    print("Error: \(error)")
                    resolver.reject(NetworkError.nonResultError)
                }
            }
    }
}
}
