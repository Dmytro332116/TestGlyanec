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
        itemTitle0.text = String(format: "%@ %@", String((item?.price)!), "₴")
        if item?.price_old != 0.0 {
            itemTitle1.text = String(format: "%@ %@", String((item?.price_old)!), "₴")
            itemLevelNumberTitle.isHidden = false
            itemTitle1.isHidden = false
        } else {
            itemTitle1.isHidden = true
            itemLevelNumberTitle.isHidden = true
        }
        
        
        setItemPreviewImageView(image:(item?.images?.first)!)
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
        let item = viewModel.itemDetails?.products.first
        
        var list: [ItemBasketModel] = []
        var listBasket: [BasketModel] = []
        if let data = UserDefaults.standard.value(forKey:"ItemBasketModel") as? Data {
            list = try! PropertyListDecoder().decode(Array<ItemBasketModel>.self, from: data)
            list.append(ItemBasketModel(id: Int((item?.id)! as String)!,
                                        title: (item?.title)! as String,
                                        price: String((item?.price)!),
                                        image: (item?.images![0])!,
                                        qty: 1))
        } else {
            list.append(ItemBasketModel(id: Int((item?.id)! as String)!,
                                        title: (item?.title)! as String,
                                        price: String((item?.price)!),
                                        image: (item?.images![0])!,
                                        qty: 1))
        }
        
        if let data = UserDefaults.standard.value(forKey:"BasketModel") as? Data {
            listBasket = try! PropertyListDecoder().decode(Array<BasketModel>.self, from: data)
            listBasket.append(BasketModel(id: Int((item?.id)! as String)!,
                                          qty: 1))
        } else {
            listBasket.append(BasketModel(id: Int((item?.id)! as String)!,
                                          qty: 1))
        }
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(list), forKey:"ItemBasketModel")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(listBasket), forKey:"BasketModel")

        self.appDelegate?.scheduleNotification(notificationType: "Товар додано в кошик", body: (item?.title)!)
        closeView()
    }

    @IBAction func basketBAction(_ sender: Any) {
        closeView()
        self.tabBarController?.selectedIndex = 3
        self.tabBarController?.tabBar.isHidden = true
    }

    @IBAction func favoriteButtonAction(_ sender: Any) {
        let item = viewModel.itemDetails?.products.first
        
        var list: [ItemBasketModel] = []
        if let data = UserDefaults.standard.value(forKey:"ItemFavoriteModel") as? Data {
            list = try! PropertyListDecoder().decode(Array<ItemBasketModel>.self, from: data)
            list.append(ItemBasketModel(id: Int((item?.id)! as String)!,
                                        title: (item?.title)! as String,
                                        price: String((item?.price)!),
                                        image: (item?.images![0])!,
                                        qty: 1))
        } else {
            list.append(ItemBasketModel(id: Int((item?.id)! as String)!,
                                        title: (item?.title)! as String,
                                        price: String((item?.price)!),
                                        image: (item?.images![0])!,
                                        qty: 1))
        }
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(list), forKey:"ItemFavoriteModel")
        closeView()
    }
}
