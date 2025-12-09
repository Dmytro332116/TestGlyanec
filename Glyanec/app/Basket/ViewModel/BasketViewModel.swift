import Foundation

class BasketViewModel: ViewModel, BaseAlert {
    
    var view: BasketViewProtocol!
    var list: [ItemBasketModel]?
    
    init(view: BasketViewProtocol, list: [ItemBasketModel]?) {
        self.view = view
        self.list = list
    }
    
//    NetworkBasket
    func getBasketList() {
        LoadingSpinner.shared.startActivity()
        if let data = UserDefaults.standard.value(forKey:"ItemBasketModel") as? Data {
            self.list = try! PropertyListDecoder().decode(Array<ItemBasketModel>.self, from: data)
        } else {
            self.list = []
        }
        
        self.view.updateItems()
        LoadingSpinner.shared.stopActivity()
    }
    
    func purchasesList() {
        LoadingSpinner.shared.startActivity()
        NetworkPurchases.purchasesList(parameters: list!)
        .done { (oModel) in
            LoadingSpinner.shared.stopActivity()
            if (oModel?.status)! {
                UserDefaults.standard.removeObject(forKey: "BasketModel")
                UserDefaults.standard.removeObject(forKey: "ItemBasketModel")
                self.list = []
                self.view.updateItems()
                self.view.openOrder(string: (oModel?.orderUrl)!)
            } else {
                let message = NetworkErrorHandler.errorMessageFrom(error: oModel?.error as! Error)
                self.displayErrorNotification(withText: message ?? "", sticky: false, action: nil, actionName: "Ok")
            }
        }
        .catch { (error) in
            LoadingSpinner.shared.stopActivity()
            print(error)
            let message = NetworkErrorHandler.errorMessageFrom(error: error)
            self.displayErrorNotification(withText: message ?? "", sticky: false, action: nil, actionName: "Ok")
        }
    }

}
