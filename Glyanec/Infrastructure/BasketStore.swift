import Foundation
import PromiseKit

final class BasketStore {
    static let shared = BasketStore()

    private(set) var items: [ItemBasketModel] = []

    private init() {}

    func refresh(completion: (() -> Void)? = nil) {
        NetworkPurchases.listItems()
            .done { [weak self] response in
                self?.items = response.items ?? []
            }
            .catch { error in
                print("Failed to refresh basket: \(error)")
            }
            .finally {
                completion?()
            }
    }

    func update(with response: BasketResponseModel?) {
        guard let response else {
            self.items = []
            return
        }
        self.items = response.items ?? []
    }
}
