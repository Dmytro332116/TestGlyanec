import Foundation

class CategoryItemsViewModel: ViewModel, BaseAlert {
    
    var view: CategoryItemsViewProtocol!
    
    var categoryProducts: ResultProductsListModel?
    var caregoryId: String?
    var caregoryName: String?
    
    init(view: CategoryItemsViewProtocol, caregoryId: String, caregoryName: String) {
        self.view = view
        self.caregoryId = caregoryId
        self.caregoryName = caregoryName
    }
        
    func getCategoryProducts() {
        LoadingSpinner.shared.startActivity()
        NetworkProducts.getCategoryProducts(categoryId: self.caregoryId!)
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
