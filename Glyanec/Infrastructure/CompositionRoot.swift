import UIKit

class CompositionRoot {

    static var sharedInstance: CompositionRoot = CompositionRoot()

    var rootTabBarController: UITabBarController!

    required init() {
        configureRootTabBarController()
    }

    @available(iOS 12.0, *)
    func updateUI(style: UIUserInterfaceStyle) {
    }
    
    private func configureRootTabBarController()
    {
        rootTabBarController = UITabBarController()
        rootTabBarController.tabBar.tintColor = ColorCompatibility.label
        rootTabBarController.tabBar.backgroundColor = .white
        rootTabBarController.tabBar.clipsToBounds = true
        
        var viewControllersList: [UIViewController] = [UIViewController]()
        let mainViewController = resolveMainViewController()
        mainViewController.tabBarItem = UITabBarItem(title: "Головна", image: UIImage(named: "home store"), tag: 1)
        mainViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        viewControllersList.append(mainViewController)

        let productsViewController = resolveProductsViewController(categories: [ResultCategorysListModel]())
        productsViewController.tabBarItem = UITabBarItem(title: "Товари", image: UIImage(named: "list"), tag: 2)
        productsViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        viewControllersList.append(productsViewController)

        let favoritesViewController = resolveFavoritesViewController()
        favoritesViewController.tabBarItem = UITabBarItem(title: "Списки", image: UIImage(named: "heart"), tag: 3)
        favoritesViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        viewControllersList.append(favoritesViewController)
        
        let basketViewController = resolveBasketViewController(list: [ItemBasketModel]())
        basketViewController.tabBarItem = UITabBarItem(title: "Кошик", image: UIImage(named: "shopping basket"), tag: 4)
        basketViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        viewControllersList.append(basketViewController)

        let viewControllers = viewControllersList.map { (viewController) -> UIViewController in
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.isHidden = true
            return navigationController
        }

        rootTabBarController.setViewControllers(viewControllers, animated: true)
    }

    // MARK: ViewControllers
    func resolveSignUpViewController() -> LogInViewController {
        let vc = LogInViewController.instantiateFromStoryboard("LogIn")
        vc.viewModel = resolveSignUpViewModel(view: vc)
        return vc
    }
    
    func resolveMainViewController() -> MainViewController {
        let vc = MainViewController.instantiateFromStoryboard("Main")
        vc.viewModel = resolveMainViewModel(view: vc)
        return vc
    }

    func resolveItemDetailsViewController(id: String) -> ItemDetailsViewController {
        let vc = ItemDetailsViewController.instantiateFromStoryboard("ItemDetails")
        vc.viewModel = resolveItemDetailsViewModel(view: vc, id: id)
        return vc
    }
    
    func resolveProductsViewController(categories: [ResultCategorysListModel]) -> ProductsViewController {
        let vc = ProductsViewController.instantiateFromStoryboard("Products")
        vc.viewModel = resolveProductsViewModel(view: vc, categories: categories)
        return vc
    }

    func resolveCategoryProductsViewController() -> CategoryViewController {
        let vc = CategoryViewController.instantiateFromStoryboard("Products")
        vc.viewModel = resolveCategoryProductsViewModel(view: vc)
        return vc
    }

    func resolveCategoryItemsViewController(caregoryId:String,
                                            caregoryName:String) -> CategoryItemsViewController {
        let vc = CategoryItemsViewController.instantiateFromStoryboard("Products")
        vc.viewModel = resolveresolveCategoryItemsModel(view: vc, caregoryId: caregoryId, caregoryName: caregoryName)
        return vc
    }
    
    func resolveFavoritesViewController() -> FavoritesViewController {
        let vc = FavoritesViewController.instantiateFromStoryboard("Favorites")
        vc.viewModel = resolveFavoritesViewModel(view: vc)
        return vc
    }

    func resolveBasketViewController(list: [ItemBasketModel]?) -> BasketViewController {
        let vc = BasketViewController.instantiateFromStoryboard("Basket")
        vc.viewModel = resolveBasketViewModel(view: vc, list: list)
        return vc
    }
    
// MARK: ViewModels
    
    func resolveSignUpViewModel(view: LogInViewProtocol) -> LogInViewModel {
        return LogInViewModel(view: view)
    }

    func resolveMainViewModel(view: MainViewProtocol) -> MainViewModel {
        return MainViewModel(view: view)
    }

    func resolveItemDetailsViewModel(view: ItemDetailsViewProtocol, id: String) -> ItemDetailsViewModel {
        return ItemDetailsViewModel(view: view, id: id)
    }
    
    func resolveProductsViewModel(view: ProductsViewProtocol, categories: [ResultCategorysListModel]) -> ProductsViewModel {
        return ProductsViewModel(view: view, categories: categories)
    }

    func resolveCategoryProductsViewModel(view: CategoryViewProtocol) -> CategoryViewModel {
        return CategoryViewModel(view: view)
    }

    func resolveresolveCategoryItemsModel(view: CategoryItemsViewProtocol, caregoryId: String, caregoryName:String) -> CategoryItemsViewModel {
        return CategoryItemsViewModel(view: view, caregoryId: caregoryId, caregoryName: caregoryName)
    }

    func resolveFavoritesViewModel(view: FavoritesViewProtocol) -> FavoritesViewModel {
        return FavoritesViewModel(view: view)
    }

    func resolveBasketViewModel(view: BasketViewProtocol, list: [ItemBasketModel]?) -> BasketViewModel {
        return BasketViewModel(view: view, list: list)
    }    
}
