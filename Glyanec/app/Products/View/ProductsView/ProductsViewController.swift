import UIKit
import SDWebImage

protocol ProductsViewProtocol {
    func reloadTableView()
    func updateItems()
}

class ProductsViewController: BaseViewController<ProductsViewModel>,ProductsViewProtocol {
    
    @IBOutlet weak var productsTV: UITableView!
    @IBOutlet weak var categoryNameL: UILabel!
        
    let catalogTVCellInditifer = "CatalogTVCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        config()
        viewModel.getCategoriesList()
    }
    
    func config() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        productsTV.refreshControl = refresh
        productsTV.contentInsetAdjustmentBehavior = .never
        
        
        
        self.productsTV.register(UINib(nibName: "CatalogTVCell", bundle: nil), forCellReuseIdentifier: catalogTVCellInditifer)        
    }
    
    func reloadTableView() {
        productsTV.reloadData()
        productsTV.refreshControl?.endRefreshing()
    }
    
    func updateItems() {
        reloadTableView()
    }
    
    @objc func reloadData() {
        viewModel.getCategoriesList()
    }
}
