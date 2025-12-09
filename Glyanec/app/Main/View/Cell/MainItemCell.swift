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

    var item: ResultProductModel?
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func config(item: ResultProductModel) {
        self.item = item
        itemTitleLabel.text = item.title
        let price = item.price ?? 0
        newPriceLabel.text = String(format: "%@ %@", String(price), "₴")
        let oldPrice = item.price_old ?? 0
        oldPriceLabel.text = String(oldPrice)
        if oldPrice != 0.0 {
            oldPriceLabel.text = String(format: "%@ %@", String(oldPrice), "₴")
            discountLabel.text = String(format: "%@ %@", String("5"), "%")
            discountLabel.isHidden = false
            oldPriceLabel.isHidden = false
            discountV.isHidden = false
        } else {
            oldPriceLabel.isHidden = true
            discountLabel.isHidden = true
            discountV.isHidden = true
        }

        let imageURL = item.images?.first ?? item.image ?? ""
        setItemPreviewImageView(image: imageURL)

        if let id = item.id {
            let isFavorite = item.is_favorite ?? FavoritesStore.shared.isFavorite(id: id)
            setFavoriteButton(isFavorite: isFavorite)
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
        guard let product = item, let productId = product.id else { return }

        let requestItem = BasketRequestItem(id: productId, qty: 1)
        LoadingSpinner.shared.startActivity()
        NetworkPurchases.addItems([requestItem])
            .done { [weak self] response in
                LoadingSpinner.shared.stopActivity()
                BasketStore.shared.update(with: response)
                if let title = product.title {
                    self?.appDelegate?.scheduleNotification(notificationType: "Товар додано в кошик", body: title)
                }
            }
            .catch { [weak self] error in
                LoadingSpinner.shared.stopActivity()
                let message = NetworkErrorHandler.errorMessageFrom(error: error)
                self?.displayErrorNotification(withText: message ?? NetworkErrorHandler.defaultErrorMessage, sticky: false, action: nil, actionName: "Ok")
            }
    }

    @IBAction func folowItemAction(_ sender: Any) {
        guard let product = item, let id = product.id else { return }
        FavoritesStore.shared.toggleFavorite(id: id) { [weak self] _ in
            DispatchQueue.main.async {
                self?.setFavoriteButton(isFavorite: FavoritesStore.shared.isFavorite(id: id))
            }
        }
    }

    private func setFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heartFavorite" : "heartUnFavorite"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
