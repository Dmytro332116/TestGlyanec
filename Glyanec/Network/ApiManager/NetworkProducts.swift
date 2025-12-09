import Foundation
import PromiseKit
import Alamofire

class NetworkProducts {
    
    static private var baseURL: String {
        return Glyanec.apiEndpoint + "basket/api/v1.0/"
    }
    
    static private var categoryProductsUrl: String {
        return baseURL + "products"
    }
    
    static func getCategoryProducts(categoryId: String) -> Promise<ResultProductsListModel?> {
        return Promise<ResultProductsListModel?> { resolver in
            NetworkSessionManager.shared
            .sessionManager
            .request(categoryProductsUrl + "?category=\(categoryId)&length=50" ,
                     method: .get,
                     parameters: nil,
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
                    let categoriesResponseModel = try JSONDecoder().decode(ResultProductsListModel.self, from: data)
                    resolver.fulfill(categoriesResponseModel)
                } catch {
                    print("Error: \(error)")
                    resolver.reject(NetworkError.nonResultError)
                }
            }
        }
    }
    
    
    static func getCategoryProducts(front: Bool) -> Promise<ResultProductsListModel?> {
        return Promise<ResultProductsListModel?> { resolver in
            NetworkSessionManager.shared
            .sessionManager
            .request(categoryProductsUrl + "?front=\(1)&length=50",
                     method: .get,
                     parameters: nil,
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
                    let categoriesResponseModel = try JSONDecoder().decode(ResultProductsListModel.self, from: data)
                    resolver.fulfill(categoriesResponseModel)
                } catch {
                    print("Error: \(error)")
                    resolver.reject(NetworkError.nonResultError)
                }
            }
        }
    }
    
    static func getProductDetails(id: Int) -> Promise<ResultProductsListModel?> {
        return Promise<ResultProductsListModel?> { resolver in
            NetworkSessionManager.shared
            .sessionManager
            .request(categoryProductsUrl + "?nid=\(id)",
                     method: .get,
                     parameters: nil,
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
                    let categoriesResponseModel = try JSONDecoder().decode(ResultProductsListModel.self, from: data)
                    resolver.fulfill(categoriesResponseModel)
                } catch {
                    print("Error: \(error)")
                    resolver.reject(NetworkError.nonResultError)
                }
            }
        }
    }
    
    static func searchByString(text: String) -> Promise<ResultProductsListModel?> {
        return Promise<ResultProductsListModel?> { resolver in
            NetworkSessionManager.shared
            .sessionManager
            .request(categoryProductsUrl + "?text=\(text)",
                     method: .get,
                     parameters: nil,
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
                    let categoriesResponseModel = try JSONDecoder().decode(ResultProductsListModel.self, from: data)
                    resolver.fulfill(categoriesResponseModel)
                } catch {
                    print("Error: \(error)")
                    resolver.reject(NetworkError.nonResultError)
                }
            }
        }
    }
}

