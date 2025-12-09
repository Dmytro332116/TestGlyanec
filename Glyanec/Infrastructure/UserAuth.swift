import Foundation

class UserAuth {
        
    static var userID: String? {
        return UserDefaults.standard.object(forKey: KeyConstant.userID) as? String
    }
    
    static var token: String? {
        return KeyChain.get(key: KeyConstant.userToken)
    }
    
//    static var refreshToken: String? {
//        return KeyChain.get(key: KeyConstant.userRefreshToken)
//    }

}
