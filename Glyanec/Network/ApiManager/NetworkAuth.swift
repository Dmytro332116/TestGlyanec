import Foundation
import PromiseKit
import Alamofire

class NetworkAuth {
    
    static private var baseUrl: String {
        return Glyanec.apiEndpoint + "api/auth/"
    }
    
    static private var tryLoginUrl: String {
        return baseUrl + "try_login"
    }

    static private var loginUrl: String {
        return baseUrl + "login"
    }

    static private var logoutUrl: String {
        return baseUrl + "logout"
    }
    
    //MARK: Authorization
    static func signIn(parameters: RequestAuthLoginModel) -> Promise<Bool> {
        return Promise<Bool> { resolver in
            NetworkSessionManager.shared
                .sessionManager
                .request(loginUrl,
                         method: .post,
                         parameters: parameters.dictionary,
                         encoding: JSONEncoding.default,
                         headers: nil)
                .validate()
                .responseJSON { response in

                    if let returnData = String(data: response.data!, encoding: .utf8) {
                      print(returnData)
                    }
                    guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }
                    if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                        return resolver.reject(APIError(errorData: errorMessage))
                    }
                    do {
                        let authLoginModel = try JSONDecoder().decode(ResultAuthLoginModel.self, from: data)
                        KeyChain.set(key: KeyConstant.userToken, string: authLoginModel.token!)
                        resolver.fulfill(true)
                    } catch {
                        print("Error: \(error)")
                        resolver.reject(NetworkError.nonResultError)
                    }
            }
        }
    }
    
    static func getCode(parameters: RequestSignUpModel) -> Promise<Bool> {
        return Promise<Bool> { resolver in
            
            NetworkSessionManager.shared
                .sessionManager
                .request("\(tryLoginUrl)"+"?phone="+"\(parameters.phone)",
                          method: .get,
                          parameters: parameters.dictionary,
                          encoding: JSONEncoding.default,
                          headers: nil)
                .validate()
                .responseJSON { response in
                    
                    guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }
                    
                    if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                        return resolver.reject(APIError(errorData: errorMessage))
                    }
                    
                    do {
                        resolver.fulfill(true)
                    } catch {
                        print("Error: \(error)")
                        resolver.reject(NetworkError.nonResultError)
                    }
            }
        }
    }
    
    static func logout() -> Promise<Bool> {
        return Promise<Bool> { resolver in
            NetworkSessionManager.shared
                .sessionManager
                .request(logoutUrl,
                         method: .post,
                         encoding: JSONEncoding.default,
                         headers: nil)
                .validate()
                .responseJSON { response in
                    
                    if let statusCode = response.response?.statusCode, statusCode >= 200, statusCode <= 300 {
                        return resolver.fulfill(true)
                    }
                    
                    guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }
                    
                    if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                        return resolver.reject(APIError(errorData: errorMessage))
                    }
                    
                    return resolver.reject(NetworkError.nonResultError)
            }
        }
    }
}
