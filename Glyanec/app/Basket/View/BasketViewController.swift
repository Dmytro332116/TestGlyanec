import UIKit
import SDWebImage

protocol BasketViewProtocol: BaseAlert {
    func config()
    func reloadTableView()
    func updateItems()
    func openOrder(string: String)
}

class BasketViewController: BaseViewController<BasketViewModel>, BasketViewProtocol {
    
    @IBOutlet weak var basketTV: UITableView!
    
    @IBOutlet weak var basketV: UIView!
    @IBOutlet weak var basketControlV: UIView!
    
    @IBOutlet weak var buyB: UIButton!
    
    let basketPriceCellInditifer = "BasketPriceCell"
    let basketItemCellInditifer = "BasketItemCell"
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getBasketList()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateItems()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }

    func config() {
        basketTV.register(UINib(nibName: "BasketItemCell", bundle: nil), forCellReuseIdentifier: basketItemCellInditifer)
        basketTV.register(UINib(nibName: "BasketPriceCell", bundle: nil), forCellReuseIdentifier: basketPriceCellInditifer)
        
        basketV.roundExtensionCorners(corners: [.topLeft, .topRight], radius: 20.0)
        basketControlV.roundExtensionCorners(corners: [.topLeft, .topRight], radius: 15.0)
        basketV.shadow()
        basketControlV.shadow()
    }
    
    func reloadTableView() {
        basketTV.reloadData()
    }
    
    func updateItems() {
        reloadTableView()
    }
    
    func openOrder(string: String) {
        if let url = URL(string: string) {
            UIApplication.shared.open(url)
        }
    }

    @objc func reloadData() {
//        viewModel.getCategoryProducts()
    }
    
    @IBAction func backBAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func buyBAction(_ sender: Any) {
        viewModel.purchasesList()
    }
}

extension BasketViewController: BasketPriceCellDelegate {
    func updatePrice(price: Double) {
        let price = String(price)
        buyB.setTitle(String(format: "Оформити %@ ", price, "₴"), for: .normal)
    }
}

extension BasketViewController: BasketItemCellDelegate {
    func removeItem(row: Int, itemTitle: String) {
        viewModel.list?.remove(at: row)
        
        var purchaiseList:[BasketModel] = []
        if let data = UserDefaults.standard.value(forKey:"BasketModel") as? Data {
            purchaiseList = try! PropertyListDecoder().decode(Array<BasketModel>.self, from: data)
            purchaiseList.remove(at: row)
        }
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(viewModel.list), forKey:"ItemBasketModel")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(purchaiseList), forKey:"BasketModel")
        
        self.basketTV.reloadData()
        
        self.appDelegate?.scheduleNotification(notificationType: "Товар видалений з кошика", body: itemTitle)
    }
}
