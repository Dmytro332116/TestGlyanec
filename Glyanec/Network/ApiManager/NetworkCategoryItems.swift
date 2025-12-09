import Foundation
import PromiseKit
import Alamofire

class NetworkCategoryItems {
    
    static private var baseURL: String {
        return Glyanec.apiEndpoint + "basket/api/v1.0/"
    }
    
//    static func addFavorite(id: String) -> Promise<Bool?> {
//        return Promise<Bool?> { resolver in
//            NetworkSessionManager.shared
//                .sessionManager
//                .request(favoritesUrl + id,
//                         method: .post,
//                         parameters: nil,
//                         encoding: JSONEncoding.default,
//                         headers: nil)
//                .validate()
//                .responseJSON { response in
//
//                    if let statusCode = response.response?.statusCode, statusCode >= 200, statusCode <= 300 {
//                        return resolver.fulfill(true)
//                    }
//
//                    guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }
//
//                    if let errorMessage = NetworkErrorHandler.containsError(data: data) {
//                        return resolver.reject(APIError(errorData: errorMessage))
//                    }
//
//                    return resolver.reject(NetworkError.nonResultError)
//            }
//        }
//    }
}

