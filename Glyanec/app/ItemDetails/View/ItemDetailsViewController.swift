import UIKit
import SDWebImage

protocol ItemDetailsViewProtocol {
    func reloadTableView()
    func updateItem()

}

class ItemDetailsViewController: BaseViewController<ItemDetailsViewModel>,ItemDetailsViewProtocol {
    @IBOutlet weak var detailsTableView: UITableView!
    
    @IBOutlet weak var previevImageView: UIImageView!
    @IBOutlet weak var itemTitle0: UILabel!
    @IBOutlet weak var itemTitle1: UILabel!
    @IBOutlet weak var itemLevelTitle: UILabel!
    @IBOutlet weak var itemLevelNumberTitle: UILabel!
    
    @IBOutlet weak var closeB: UIButton!
    @IBOutlet weak var payB: UIButton!
    @IBOutlet weak var basketB: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var arrayM = NSMutableArray()
    var arrayMBA = NSMutableArray()
    
    let itemCharacteristicsCell = "ItemCharacteristicsCell"
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getItemDetails()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }

    func config() {
        detailsTableView.register(UINib(nibName: "ItemCharacteristicsCell", bundle: nil), forCellReuseIdentifier: itemCharacteristicsCell)
    }
    
    func updateCurrentItem() {
        let item = viewModel.itemDetails?.products.first

        itemLevelTitle.text = item?.title
        if let price = item?.price {
            itemTitle0.text = String(format: "%@ %@", String(price), "₴")
        }
        if let oldPrice = item?.price_old, oldPrice != 0.0 {
            itemTitle1.text = String(format: "%@ %@", String(oldPrice), "₴")
            itemLevelNumberTitle.isHidden = false
            itemTitle1.isHidden = false
        } else {
            itemTitle1.isHidden = true
            itemLevelNumberTitle.isHidden = true
        }

        let preview = item?.images?.first ?? item?.image ?? ""
        setItemPreviewImageView(image: preview)

        if let productId = item?.id {
            updateFavoriteButton(isFavorite: FavoritesStore.shared.isFavorite(id: productId))
        }
    }
    
    func setItemPreviewImageView(image:String) {
        if let imageCache = SDImageCache.shared.imageFromCache(forKey: image) {
            previevImageView.image = imageCache
        } else {
            if let url = URL(string: image) {
                previevImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }

    
    func updateItem() {
        updateCurrentItem()
        
        reloadTableView()
    }
    
    func reloadTableView() {
        detailsTableView.reloadData()
    }
    
    func closeView() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBAction(_ sender: Any) {
        closeView()
    }
    
    @IBAction func payBAction(_ sender: Any) {
        guard let item = viewModel.itemDetails?.products.first,
              let productId = item.id else { return }
        let requestItem = BasketRequestItem(id: productId, qty: 1)

        LoadingSpinner.shared.startActivity()
        NetworkPurchases.addItems([requestItem])
            .done { [weak self] response in
                LoadingSpinner.shared.stopActivity()
                BasketStore.shared.update(with: response)
                if let title = item.title {
                    self?.appDelegate?.scheduleNotification(notificationType: "Товар додано в кошик", body: title)
                }
                self?.closeView()
            }
            .catch { [weak self] error in
                LoadingSpinner.shared.stopActivity()
                let message = NetworkErrorHandler.errorMessageFrom(error: error)
                self?.displayErrorNotification(withText: message ?? NetworkErrorHandler.defaultErrorMessage, sticky: false, action: nil, actionName: "Ok")
            }
    }

    @IBAction func basketBAction(_ sender: Any) {
        closeView()
        self.tabBarController?.selectedIndex = 3
        self.tabBarController?.tabBar.isHidden = true
    }

    @IBAction func favoriteButtonAction(_ sender: Any) {
        guard let item = viewModel.itemDetails?.products.first,
              let productId = item.id else { return }

        FavoritesStore.shared.toggleFavorite(id: productId) { [weak self] isSuccess in
            DispatchQueue.main.async {
                self?.updateFavoriteButton(isFavorite: FavoritesStore.shared.isFavorite(id: productId))
                if isSuccess, let title = item.title {
                    self?.appDelegate?.scheduleNotification(notificationType: "Оновлено вибрані", body: title)
                }
            }
        }
    }

    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heartFavorite" : "heartUnFavorite"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
