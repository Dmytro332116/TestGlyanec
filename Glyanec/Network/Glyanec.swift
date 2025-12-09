import Foundation
import Alamofire

class Glyanec {
    
    static var apiEndpoint: String {
        return glyanecBaseUrl
    }
}

class NetworkSessionManager {
    
    static let shared = NetworkSessionManager()
    var sessionManager: SessionManager
    
    init() {
        let configuration = URLSessionConfiguration.default
        var headers = SessionManager.defaultHTTPHeaders
        let accessToken = KeyChain.get(key:  KeyConstant.userToken)

        headers["Content-Type"] = "application/json"
        headers["accept-language"] = Locale.current.languageCode
        
        if let accessToken, !accessToken.isEmpty {
            headers["X-TOKEN"] = accessToken
        }
        
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 60.0
        let adapter = JWTAccessTokenAdapter()

        self.sessionManager = SessionManager(
            configuration: configuration
        )
        self.sessionManager.adapter = adapter
        self.sessionManager.retrier = adapter
    }
}
