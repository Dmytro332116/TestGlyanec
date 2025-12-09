import Alamofire
import Foundation
import PromiseKit

final class JWTAccessTokenAdapter: RequestAdapter {
    private let lock = NSLock()
    private var isRefreshingToken: Bool = false
    private var requestsToRetry: [(Bool) -> Void] = []

    private var accessToken = ""

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        accessToken = UserAuth.token ?? ""
        print("AccessToken",accessToken,"urlRequest = ", urlRequest)

        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(Glyanec.apiEndpoint) {
            urlRequest.setValue(accessToken, forHTTPHeaderField: "X-TOKEN")
        }

        return urlRequest
    }
}

extension JWTAccessTokenAdapter: RequestRetrier {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
            guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
                if let response = request.task?.response as? HTTPURLResponse {
                    print("response.statusCode", response.statusCode )
                }
                completion(false, 0)
                return
            }
            print("response.statusCode", response.statusCode)

            lock.lock(); defer { lock.unlock() }

            requestsToRetry.append { shouldRetry in
                completion(shouldRetry, 0)
            }

            guard !isRefreshingToken else { return }

            isRefreshingToken = true
            guard let refreshToken = UserAuth.refreshToken, !refreshToken.isEmpty else {
                completeRetries(shouldRetry: false)
                clearTokens()
                return
            }

            NetworkAuth.refreshToken(refreshToken: refreshToken)
                .done { model in
                    if let token = model.token {
                        KeyChain.set(key: KeyConstant.userToken, string: token)
                        self.accessToken = token
                    }
                    if let refreshToken = model.refresh_token {
                        KeyChain.set(key: KeyConstant.userRefreshToken, string: refreshToken)
                    }
                    self.completeRetries(shouldRetry: true)
                }
                .catch { error in
                    print("Refresh token failed: \(error)")
                    self.clearTokens()
                    self.completeRetries(shouldRetry: false)
                }
    }

    private func clearTokens() {
        KeyChain.set(key: KeyConstant.userToken, string: "")
        KeyChain.set(key: KeyConstant.userRefreshToken, string: "")
    }

    private func completeRetries(shouldRetry: Bool) {
        lock.lock(); defer { lock.unlock() }
        isRefreshingToken = false
        let queuedRequests = requestsToRetry
        requestsToRetry.removeAll()
        queuedRequests.forEach { completion in
            completion(shouldRetry)
        }
    }
}
