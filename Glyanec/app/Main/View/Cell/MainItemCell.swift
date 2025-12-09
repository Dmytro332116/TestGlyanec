import UIKit
import SDWebImage
import UserNotifications

class MainItemCell: UICollectionViewCell, BaseAlert, UNUserNotificationCenterDelegate  {
    
    @IBOutlet weak var discountV: UIView!
    
    @IBOutlet weak var itemIV: UIImageView!
    
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
        
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    
    var item: ResultProductModel!
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func config(item: ResultProductModel) {
        self.item = item
        itemTitleLabel.text = item.title
        newPriceLabel.text = String(format: "%@ %@", String(item.price!), "₴")
        oldPriceLabel.text = String(item.price_old!)
        if item.price_old! != 0.0 {
            oldPriceLabel.text = String(format: "%@ %@", String(item.price_old!), "₴")
            discountLabel.text = String(format: "%@ %@", String("5"), "%")
            discountLabel.isHidden = false
            oldPriceLabel.isHidden = false
            discountV.isHidden = false
        } else {
            oldPriceLabel.isHidden = true
            discountLabel.isHidden = true
            discountV.isHidden = true
        }

        if let firstImage = item.images?.first {
            setItemPreviewImageView(image: firstImage)
        } else {
            setItemPreviewImageView(image: "")  // або пустий url
        }

    }
    
    func setItemPreviewImageView(image:String) {
        if let imageCache = SDImageCache.shared.imageFromCache(forKey: image) {
            itemIV.image = imageCache
        } else {
            if let url = URL(string: image) {
                itemIV.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
//    func setFavoriteButton(fav_item: [ResultFavItemModel]?) {
//        if fav_item?.count == 0 {
//            favoriteButton.setImage(UIImage(named: "heartUnFavorite"), for: .normal)
//        } else {
//            favoriteButton.setImage(UIImage(named: "heartFavorite"), for: .normal)
//        }
//    }
        
    @IBAction func buyItemAction(_ sender: Any) {
        var list: [ItemBasketModel] = []
        var listBasket: [BasketModel] = []
        if let data = UserDefaults.standard.value(forKey:"ItemBasketModel") as? Data {
            list = try! PropertyListDecoder().decode(Array<ItemBasketModel>.self, from: data)
            list.append(ItemBasketModel(id: Int(self.item.id! as String)!,
                                        title: self.item.title! as String,
                                        price: String(self.item.price!),
                                        image: self.item.images![0],
                                        qty: 1))
        } else {
            list.append(ItemBasketModel(id: Int(self.item.id! as String)!,
                                        title: self.item.title! as String,
                                        price: String(self.item.price!),
                                        image: self.item.images![0],
                                        qty: 1))
        }
        
        if let data = UserDefaults.standard.value(forKey:"BasketModel") as? Data {
            listBasket = try! PropertyListDecoder().decode(Array<BasketModel>.self, from: data)
            listBasket.append(BasketModel(id: Int(self.item.id! as String)!,
                                          qty: 1))
        } else {
            listBasket.append(BasketModel(id: Int(self.item.id! as String)!,
                                          qty: 1))
        }
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(list), forKey:"ItemBasketModel")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(listBasket), forKey:"BasketModel")
        
        self.appDelegate?.scheduleNotification(notificationType: "Товар додано в кошик", body: self.item.title!)
    }
    
    @IBAction func folowItemAction(_ sender: Any) {
//        LoadingSpinner.shared.startActivity()
//        NetworkFavorites.addFavorite(id: id)
//            .done { (oModel) in
//                LoadingSpinner.shared.stopActivity()
////                self.view.reloadTableView()
//                if let model = oModel {
////                    self.items = model
//                }
////                self.view.updateItems()
//        }
//        .catch { (error) in
//            LoadingSpinner.shared.stopActivity()
////            self.view.reloadTableView()
//            print(error)
//            let message = NetworkErrorHandler.errorMessageFrom(error: error)
//            self.displayErrorNotification(withText: message ?? "", sticky: false, action: nil, actionName: "Ok")
//        }
    }
}
