import Foundation
import PromiseKit
import Alamofire
//import FirebaseAnalytics

class NetworkUserProfile {
    
    static private var baseUrl: String {
        return Glyanec.apiEndpoint
    }
    
    static private var profilesUrl: String {
        return Glyanec.apiEndpoint + "profiles/"
    }
    
    static func getUserProfile(userId: String) -> Promise<ResultUserProfileModel?> {
        print("getUserProfile --> userID: \(userId)")
        return Promise<ResultUserProfileModel?> { resolver in
            NetworkSessionManager.shared
                .sessionManager
                .request(profilesUrl + "\(userId)",
                    method: .get,
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
                        let userProfileModel = try JSONDecoder().decode(ResultUserProfileModel.self, from: data)
                        resolver.fulfill(userProfileModel)
                    } catch {
                        print("Error: \(error)")
                        resolver.reject(NetworkError.nonResultError)
                    }
            }
        }
    }
    
    
    static func updateUserProfile(parameters:RequestUserProfileApiModel) -> Promise<Bool?>
    {
        print(parameters.dictionary as Any)
        return Promise<Bool?> { resolver in
            
//            Analytics.logEvent("updateUserProfile_request", parameters: [
//                "url" : profilesUrl,
//                "birthday" : parameters.birthday,
//                "gender" : parameters.gender,
//                "nickname" : parameters.nickname,
//                "signature" : parameters.signature,
//                "uniqueID" : parameters.uniqueID
//            ])
            
            NetworkSessionManager.shared
                .sessionManager
                .request(profilesUrl,
                         method: .patch,
                         parameters: parameters.dictionary,
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
    
    static func delete() -> Promise<Bool> {
        return Promise<Bool> { resolver in
            
//            Analytics.logEvent("deleteProfile_request", parameters: [
//                "url" : profilesUrl
//            ])
            
            NetworkSessionManager.shared
                .sessionManager
                .request(profilesUrl,
                         method: .delete,
                         parameters: nil,
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
    
    static func uploadAvatar(data: Data, fileName: String) -> Promise<Bool> {
        return Promise<Bool> { resolver in
            NetworkSessionManager.shared
                .sessionManager
                .upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: "image/jpeg")
                }, usingThreshold: UInt64.init(),
                   to: baseUrl + "avatars",
                    method: .post
//                    headers: Glyanec.multipartHeaders
                    )
                { result in
                    switch result {
                        
                    case .success(let upload, _, _):
                        upload.responseString { response in
                                if let statusCode = response.response?.statusCode, statusCode >= 200, statusCode <= 300 {
                                    return resolver.fulfill(true)
                                }
                                
                                guard let data = response.data else { return resolver.reject(NetworkError.nonResultError) }
                                
                                if let errorMessage = NetworkErrorHandler.containsError(data: data) {
                                    return resolver.reject(APIError(errorData: errorMessage))
                                }
                                
                                return resolver.reject(NetworkError.nonResultError)
                            }
                            .validate()
                    case .failure(let error):
                        resolver.reject(error)
                    }
            }
        }
    }
}
