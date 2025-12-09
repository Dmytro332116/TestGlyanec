import Alamofire
import Foundation

final class JWTAccessTokenAdapter: RequestAdapter {
    
//    private var isRefreshingToken: Bool = false
    
    private var accessToken = ""
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        accessToken = UserAuth.token ?? ""
        print("AccessToken",accessToken,"urlRequest = ", urlRequest)
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix("http://81.171.24.179:8090") {
//            /// Set the Authorization header value using the access token.
//            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("Token " + accessToken , forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}

extension JWTAccessTokenAdapter: RequestRetrier {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
//        let isRefreshTokenRequest = request.request?.url?.absoluteString.hasSuffix("auth/refresh") ?? false
//        if !isRefreshTokenRequest || !isRefreshingToken {
            
            guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
                if let response = request.task?.response as? HTTPURLResponse {
                    print("response.statusCode", response.statusCode )
                }
                completion(false, 0)
                return
            }
            print("response.statusCode", response.statusCode)
//            isRefreshingToken = true
//            NetworkAuth.reffreshToken()
//                .done { (model) in
//                    self.isRefreshingToken = false
//                    self.accessToken = model.accessToken
//                    completion(true, 1)
//            }
//            .catch { (error) in
//                // Save important values
//                let savingState = UserDefaults.standard.object(forKey: KeyConstant.rememberAccount)
//                let unsignMode = UserDefaults.standard.bool(forKey: KeyConstant.isInUnsignMode)
//
//                // Clean all user defaults
//                let domain = Bundle.main.bundleIdentifier!
//                UserDefaults.standard.removePersistentDomain(forName: domain)
//                UserDefaults.standard.synchronize()
//                print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
//
//                UserDefaults.standard.set(savingState, forKey: KeyConstant.rememberAccount)
//                UserDefaults.standard.set(unsignMode, forKey: KeyConstant.isInUnsignMode)
//                UserDefaults.standard.synchronize()
//
////                VideoModel.shared.clearCache()
//                if !CurrentUser.shared.isInUnsignMode
//                {
////                    Coordinator.shared.showLoginViewController()
//                }
//
//                completion(false, 0)
//            }
//        } else {
//            completion(false, 0)
//        }
    }
}
