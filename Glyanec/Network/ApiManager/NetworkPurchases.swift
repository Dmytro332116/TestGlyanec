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


    
static func purchasesList(parameters: [ItemBasketModel]) -> Promise<ResultPurchaiseModel?> {
    
    var purchaiseList:[BasketModel] = []
    if let data = UserDefaults.standard.value(forKey:"BasketModel") as? Data {
        purchaiseList = try! PropertyListDecoder().decode(Array<BasketModel>.self, from: data)
    } else {}

    let list: [String: [BasketModel]] = ["list":purchaiseList]
    
        return Promise<ResultPurchaiseModel?> { resolver in
            NetworkSessionManager.shared
                .sessionManager
                .request(purchases,
                         method: .post,
                         parameters: list.dictionary,
                         encoding: JSONEncoding.default,
                         headers: nil)
                .validate()
                .responseJSON { response in
                    guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }
                    
                    if let returnData = String(data: response.data!, encoding: .utf8) {
                      print(returnData)
                    }

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
}
