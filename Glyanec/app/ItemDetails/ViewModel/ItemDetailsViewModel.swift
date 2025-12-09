import Foundation
import Alamofire
import UIKit

class ItemDetailsViewModel: ViewModel, BaseAlert {
    
    var view: ItemDetailsViewProtocol!
    
    var itemDetails: ResultProductsListModel?
    var id: Int?
    
    init(view: ItemDetailsViewProtocol, id: String) {
        self.view = view
        self.id = Int(id)
    }
    
    func getItemDetails() {
        LoadingSpinner.shared.startActivity()
        NetworkProducts.getProductDetails(id: self.id!)
            .done { (oModel) in
                LoadingSpinner.shared.stopActivity()
                self.view.reloadTableView()
                if let model = oModel {
                    self.itemDetails = model
                }
                self.view.updateItem()
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
