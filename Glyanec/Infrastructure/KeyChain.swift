import Foundation
import Security

//import KeychainSwift

//class KeyChain {
//    let keychain = KeychainSwift()
//
////    class
//    func set(key: String, string: String) {
//        keychain.set(string, forKey: key)
//    }
//
//    func get(key: String) -> String? {
//        return keychain.get("my key") as String?
//    }
//}

class KeyChain {

    class func set(key: String, string: String) {
        
        guard let data = string.data(using: .utf8) else { return }
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)
        print(SecItemAdd(query as CFDictionary, nil))
    }

    class func get(key: String) -> String? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil
        var contentsOfKeychain: String?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        return contentsOfKeychain
    }
}
