import UIKit
import SDWebImage

protocol CategoryViewProtocol {
    func reloadTableView()
    func updateItems()
}

class CategoryViewController: BaseViewController<CategoryViewModel>, CategoryViewProtocol {
    
    @IBOutlet weak var categoryTV: UITableView!
        
    let catalogTVCellInditifer = "CatalogTVCell"
    let catalogItemsTVCellInditifer = "CatalogItemsTVCell"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        config()
        viewModel.getCategoryProducts()
    }
    
    func config() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        categoryTV.refreshControl = refresh
        categoryTV.contentInsetAdjustmentBehavior = .never
        
        self.categoryTV.register(UINib(nibName: "CatalogTVCell", bundle: nil), forCellReuseIdentifier: catalogTVCellInditifer)
        self.categoryTV.register(UINib(nibName: "CatalogItemsTVCell", bundle: nil), forCellReuseIdentifier: catalogItemsTVCellInditifer)
    }
    
    func reloadTableView() {
        categoryTV.reloadData()
        categoryTV.refreshControl?.endRefreshing()
    }
    
    func updateItems() {
        reloadTableView()
    }
    
    @objc func reloadData() {
        viewModel.getCategoryProducts()
    }
}
