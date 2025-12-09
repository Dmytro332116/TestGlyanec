
import Foundation
import UIKit

class NetworkErrorHandler {
    
    static func containsError(data: Data) -> (String?) {

        var dataDict = [String : Any]()
        do {
            let decoded = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictFromJSON = decoded as? [String : Any] { dataDict = dictFromJSON }
            else { return nil }
        } catch {
            print(error.localizedDescription)
            return nil
        }

        if let message = dataDict[KeyConstant.message] as? String { return message }
        if let messageArraged = dataDict[KeyConstant.message] as? [String] {
            var mes = ""
            messageArraged.forEach { mes += $0 }
            return mes
        }
        if let error = dataDict[KeyConstant.error] as? String { return error }

        return nil
    }
    
    static func errorMessageFrom(error: Error) -> (String?) {
        guard let message = (error as?  APIError<String>)?.errorData else {
            return defaultErrorMessage
        }
        return message
    }

}

public enum NetworkError: Error {
    case nonResultError
    case apiError(error: Error)
    case genericError(error: GenericNetworkError)
    case unknown(error: Error)
}

public enum GenericNetworkError: Error {
    case underlyingNetworkError(error: Error)
    case parsingResponseError(error: Error)
}

public struct APIError<T>: Error {
    let errorData: T
}

public enum FileError: Error {
    case fileAlreadyExists
    case fileNotAvailable
}
