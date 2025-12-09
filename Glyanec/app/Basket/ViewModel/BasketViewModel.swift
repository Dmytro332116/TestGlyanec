import Foundation

class BasketViewModel: ViewModel, BaseAlert {

    var view: BasketViewProtocol!
    var list: [ItemBasketModel]?

    init(view: BasketViewProtocol, list: [ItemBasketModel]?) {
        self.view = view
        self.list = list
    }

    func getBasketList() {
        LoadingSpinner.shared.startActivity()

        NetworkPurchases.listItems()
            .done { [weak self] response in
                LoadingSpinner.shared.stopActivity()
                self?.list = response.items ?? []
                BasketStore.shared.update(with: response)
                self?.view.updateItems()
            }
            .catch { [weak self] error in
                LoadingSpinner.shared.stopActivity()
                self?.list = []
                self?.view.updateItems()
                let message = NetworkErrorHandler.errorMessageFrom(error: error)
                self?.displayErrorNotification(withText: message ?? NetworkErrorHandler.defaultErrorMessage, sticky: false, action: nil, actionName: "Ok")
            }
    }

    func purchasesList() {
        LoadingSpinner.shared.startActivity()
        guard let list, !list.isEmpty else {
            LoadingSpinner.shared.stopActivity()
            self.list = []
            self.view.updateItems()
            return
        }

        let requestItems = list.compactMap { item -> BasketRequestItem? in
            guard let id = item.id else { return nil }
            return BasketRequestItem(id: id, qty: item.qty ?? 1)
        }

        NetworkPurchases.checkout(items: requestItems)
        .done { [weak self] oModel in
            LoadingSpinner.shared.stopActivity()
            if let status = oModel?.status, status {
                BasketStore.shared.update(with: nil)
                self?.list = []
                self?.view.updateItems()
                if let url = oModel?.orderUrl {
                    self?.view.openOrder(string: url)
                }
            } else {
                let message = oModel?.error?.first?.message ?? NetworkErrorHandler.defaultErrorMessage
                self?.displayErrorNotification(withText: message ?? "", sticky: false, action: nil, actionName: "Ok")
            }
        }
        .catch { [weak self] error in
            LoadingSpinner.shared.stopActivity()
            let message = NetworkErrorHandler.errorMessageFrom(error: error)
            self?.displayErrorNotification(withText: message ?? "", sticky: false, action: nil, actionName: "Ok")
        }
    }

    func removeItem(at index: Int) {
        guard let list, index < list.count else { return }
        let item = list[index]
        guard let id = item.id else { return }
        LoadingSpinner.shared.startActivity()
        NetworkPurchases.removeItems([BasketRequestItem(id: id, qty: item.qty ?? 1)])
            .done { [weak self] response in
                LoadingSpinner.shared.stopActivity()
                self?.list = response.items ?? []
                BasketStore.shared.update(with: response)
                self?.view.updateItems()
            }
            .catch { [weak self] error in
                LoadingSpinner.shared.stopActivity()
                let message = NetworkErrorHandler.errorMessageFrom(error: error)
                self?.displayErrorNotification(withText: message ?? NetworkErrorHandler.defaultErrorMessage, sticky: false, action: nil, actionName: "Ok")
            }
    }
}
