import UIKit
import SDWebImage
import UserNotifications

protocol MainViewProtocol {
    func reloadTableView()
    func updateItems()
    func closeViewController()
}

class MainViewController: BaseViewController<MainViewModel>, MainViewProtocol {
    
    @IBOutlet weak var headerV: UIView!
    @IBOutlet weak var searchV: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchCloseB: UIButton!
    @IBOutlet weak var mainCV: UICollectionView!
    
    var refreshControl = UIRefreshControl()
        
    let mainItemCollectionCellInditifer = "MainItemCell"
    let mainTopActionCellInditifer = "MainTopActionCell"
    
    let categoriesCollectionCellInditifer = "CategoriesCVCell"
    
    var countCection:Int = 0
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        mainCV.refreshControl = refresh
        mainCV.contentInsetAdjustmentBehavior = .never
        
        self.mainCV.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: mainItemCollectionCellInditifer)
        self.mainCV.register(UINib(nibName: "CategoriesCVCell", bundle: nil), forCellWithReuseIdentifier: categoriesCollectionCellInditifer)
        self.mainCV.register(UINib(nibName: "MainTopActionCell", bundle: nil), forCellWithReuseIdentifier: mainTopActionCellInditifer)

        
        searchTextField.addTarget(self, action: #selector(MainViewController.textFieldDidChange(_:)), for: .editingChanged)
        searchCloseB.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCategoryProducts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        headerV.roundExtensionCorners(corners: [.bottomLeft, .bottomRight], radius: 15.0)
        searchV.roundExtensionCorners(corners: [.bottomLeft, .bottomRight], radius: 15.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }

    func reloadTableView() {
        mainCV.reloadData()
        mainCV.refreshControl?.endRefreshing()
    }
    
    @objc func reloadData() {
        viewModel.getCategoryProducts()
    }
    
    func closeViewController() {
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (textField.text!.count > 2) {
            viewModel.searchByString(text: textField.text!)
        }
    }
        
    @IBAction func searchCloseBAction(_ sender: Any) {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        searchCloseB.isHidden = true
        viewModel.getCategoryProducts()
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField1: UITextField) {
        searchCloseB.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
