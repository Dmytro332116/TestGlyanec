import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var dataJSON: Data? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        let dic = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
        return try? JSONSerialization.data(withJSONObject: dic!, options: .prettyPrinted)
    }
}
