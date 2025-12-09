import Foundation


class ProductsViewModel: ViewModel, BaseAlert {
    
    var view: ProductsViewProtocol!
    
    var userID = ""
    var categories: [ResultCategorysListModel]?
    
    init(view: ProductsViewProtocol, categories: [ResultCategorysListModel]) {
        self.view = view
        self.categories = categories
    }
        
    func getCategoriesList() {
        LoadingSpinner.shared.startActivity()
        NetworkCategories.getCategoriesList()
        .done { (oModel) in
            LoadingSpinner.shared.stopActivity()
            self.view.reloadTableView()
            if let model = oModel {
                self.categories = model
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
