import Foundation
import Alamofire

class Glyanec {
    
    static var apiEndpoint: String {
        return "https://v3magazin.glyanec.net/"
    }
}

class NetworkSessionManager {
    
    static let shared = NetworkSessionManager()
    var sessionManager: SessionManager
    
    init() {
        let configuration = URLSessionConfiguration.default
        var headers = SessionManager.defaultHTTPHeaders
        let accessToken = KeyChain.get(key:  KeyConstant.userToken) ?? "HsjMeygEdGkgtsB5QnpovXM22nuzifon"

        headers["Content-Type"] = "application/json"
        headers["accept-language"] = Locale.current.languageCode
        
        if accessToken.count > 0 {
            headers["X-TOKEN"] = "HsjMeygEdGkgtsB5QnpovXW22nuzifon"
        }
        
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 60.0
                
        self.sessionManager = SessionManager(
            configuration: configuration
        )
//        [
//        self.sessionManager = SessionManager(
//            configuration: configuration
//        )
        
//        let adapter = JWTAccessTokenAdapter()
//        self.sessionManager.adapter = adapter
//        self.sessionManager.retrier = adapter
    }
}
