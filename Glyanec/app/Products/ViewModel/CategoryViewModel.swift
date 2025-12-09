import Foundation

class CategoryViewModel: ViewModel, BaseAlert {
    
    var view: CategoryViewProtocol!
    
    var userID = ""
    var categoryProducts: ResultProductsListModel?
    
    init(view: CategoryViewProtocol) {
        self.view = view
    }
        
    func getCategoryProducts() {
        LoadingSpinner.shared.startActivity()
        NetworkCategories.getCategoryProducts()
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
