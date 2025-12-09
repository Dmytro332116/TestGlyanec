import Foundation

class FavoritesViewModel: ViewModel, BaseAlert {
    
    var view: FavoritesViewProtocol!
//    var items: [ResultItemListModel]?
    
    init(view: FavoritesViewProtocol) {
        self.view = view
//        self.items = []
    }
    
//    NetworkFavorites
    func getFavoritesList() {
//        LoadingSpinner.shared.startActivity()
//        NetworkFavorites.getFavoritesList()
//            .done { (oModel) in
//                LoadingSpinner.shared.stopActivity()
//                if let model = oModel {
//                    self.items = model
//                }
//                self.view.updateCollection()
//        }
//        .catch { (error) in
//            LoadingSpinner.shared.stopActivity()
//            self.view.updateCollection()
//            print(error)
//            let message = NetworkErrorHandler.errorMessageFrom(error: error)
//            self.displayErrorNotification(withText: message ?? "", sticky: false, action: nil, actionName: "Ok")
//        }
    }
    
    func addFavorite(id: String) {
        LoadingSpinner.shared.startActivity()
        NetworkFavorites.addFavorite(id: id)
            .done { (oModel) in
                LoadingSpinner.shared.stopActivity()
                self.view.config()
        }
        .catch { (error) in
            LoadingSpinner.shared.stopActivity()
            self.view.config()
            print(error)
            let message = NetworkErrorHandler.errorMessageFrom(error: error)
            self.displayErrorNotification(withText: message ?? "", sticky: false, action: nil, actionName: "Ok")
        }
    }
}
