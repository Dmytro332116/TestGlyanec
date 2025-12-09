import Foundation
import PromiseKit
import Alamofire

class NetworkCategories {
    
    static private var baseURL: String {
        return Glyanec.apiEndpoint + "basket/api/v1.0/"
    }
    
    static private var categoriesUrl: String {
        return baseURL + "categorylist"
    }
    
    static private var categoryProductsUrl: String {
        return baseURL + "products"
    }
    
    static func getCategoriesList() -> Promise<[ResultCategorysListModel]?> {
        return Promise<[ResultCategorysListModel]?> { resolver in
            NetworkSessionManager.shared
                .sessionManager
                 .request(categoriesUrl,
                         method: .get,
                         parameters: nil,
                         encoding: JSONEncoding.default,
                         headers: nil)
                .validate()
                .responseJSON { response in
                    print(response)

                    guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }

                    if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                        return resolver.reject(APIError(errorData: errorMessage))}
                    
                    do { let categoriesResponseModel = try JSONDecoder().decode([ResultCategorysListModel].self, from: data)
                        print (categoriesResponseModel)
                        resolver.fulfill(categoriesResponseModel)
                    } catch {
                        print("Error: \(error)")
                        resolver.reject(NetworkError.nonResultError)
                    }
            }
        }
    }
    
    
    static func getCategoryProducts() -> Promise<ResultProductsListModel?> {
        return Promise<ResultProductsListModel?> { resolver in
            NetworkSessionManager.shared
                .sessionManager
                 .request(categoryProductsUrl,
                         method: .get,
                         parameters: nil,
                         encoding: JSONEncoding.default,
                         headers: nil)
                .validate()
                .responseJSON { response in

                    print(response)

                    guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }

//                    let responseData = String(data: response.data!, encoding: String.Encoding.utf8)
//                    print(responseData as Any)

                    if let returnData = String(data: response.data!, encoding: .utf8) {
                      print(returnData)
                    }

                    if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                        return resolver.reject(APIError(errorData: errorMessage))
                    }
                    do {
                        let categoriesResponseModel = try JSONDecoder().decode(ResultProductsListModel.self, from: data)
                        print (categoriesResponseModel)
                        resolver.fulfill(categoriesResponseModel)
                    } catch {
                        print("Error: \(error)")
                        resolver.reject(NetworkError.nonResultError)
                    }
            }
        }
    }
}

