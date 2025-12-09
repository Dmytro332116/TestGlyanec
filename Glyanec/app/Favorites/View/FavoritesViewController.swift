import UIKit
import SDWebImage

protocol FavoritesViewProtocol: BaseAlert {
    func config()
}

class FavoritesViewController: BaseViewController<FavoritesViewModel>, FavoritesViewProtocol {
    @IBOutlet weak var favoriteTV: UITableView!
        
    let favoriteListCellInditifer = "FavoriteListTVCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateItems()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }

    func config() {
        favoriteTV.register(UINib(nibName: favoriteListCellInditifer, bundle: nil), forCellReuseIdentifier: favoriteListCellInditifer)
        viewModel.getFavoritesList()
    }
    
    func reloadTableView() {
        favoriteTV.reloadData()
    }
    
    func updateItems() {
        reloadTableView()
    }
    
    @objc func reloadData() {
//        viewModel.getCategoryProducts()
    }
}

