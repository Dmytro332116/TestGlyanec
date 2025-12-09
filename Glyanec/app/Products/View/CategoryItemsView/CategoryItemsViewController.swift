import UIKit
import SDWebImage

protocol CategoryItemsViewProtocol {
    func reloadTableView()
    func updateItems()
}

class CategoryItemsViewController: BaseViewController<CategoryItemsViewModel>, CategoryItemsViewProtocol {
    
    @IBOutlet weak var categoryItemsVCV: UICollectionView!
    @IBOutlet weak var categoryNameL: UILabel!

    var refreshControl = UIRefreshControl()
    
    let mainItemCollectionCellInditifer = "MainItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func config() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        categoryItemsVCV.refreshControl = refresh
        categoryItemsVCV.contentInsetAdjustmentBehavior = .never
        
        self.categoryItemsVCV.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: mainItemCollectionCellInditifer)
        
        categoryNameL.text = viewModel.caregoryName
    }
            
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCategoryProducts()
        config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }

    func reloadTableView() {
        categoryItemsVCV.reloadData()
        categoryItemsVCV.refreshControl?.endRefreshing()
    }
    
    @objc func reloadData() {
        viewModel.getCategoryProducts()
    }
    
    func closeViewController() {
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }

}
