import Foundation
import Alamofire
import UIKit

class MainViewModel: ViewModel, BaseAlert {
    
    var view: MainViewProtocol!
    var categoryProducts: ResultProductsListModel?
    private var searchWorkItem: DispatchWorkItem?
    
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
        searchWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            LoadingSpinner.shared.startActivity()
            NetworkProducts.searchByString(text: text)
            .done { (oModel) in
                LoadingSpinner.shared.stopActivity()
                self.view.reloadTableView()
                if let model = oModel {
                    self.categoryProducts = model
                } else {
                    self.categoryProducts = ResultProductsListModel(total: nil, pages: nil, length: nil, page: nil, products: [])
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

        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
}
