import Foundation
import Alamofire
import UIKit

class MainViewModel: ViewModel, BaseAlert {
    
    var view: MainViewProtocol!
    var categoryProducts: ResultProductsListModel?
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    func getCategoryProducts() {
        LoadingSpinner.shared.startActivity()
        NetworkProducts.getCategoryProducts(front: true)
        .done { (oModel) in
            LoadingSpinner.shared.stopActivity()
            self.view.reloadTableView()
            if let model = oModel {
                self.categoryProducts = model
            }
            self.view.updateItems()
        }
        .catch { (error) in
            LoadingSpinner.shared.stopActivity()
            self.view.reloadTableView()
            print(error)
            let message = NetworkErrorHandler.errorMessageFrom(error: error)
            self.displayErrorNotification(withText: message ?? "", sticky: false, action: nil, actionName: "Ok")
        }
    }
    
    func searchByString(text: String) {
        LoadingSpinner.shared.startActivity()
        NetworkProducts.searchByString(text: text)
        .done { (oModel) in
            LoadingSpinner.shared.stopActivity()
            self.view.reloadTableView()
            if let model = oModel {
                self.categoryProducts = model
            }
            self.view.updateItems()
        }
        .catch { (error) in
            LoadingSpinner.shared.stopActivity()
            self.view.reloadTableView()
            print(error)
            let message = NetworkErrorHandler.errorMessageFrom(error: error)
            self.displayErrorNotification(withText: message ?? "", sticky: false, action: nil, actionName: "Ok")
        }
    }
}
