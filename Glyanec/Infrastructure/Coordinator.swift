import UIKit

class Coordinator {
    
    static let shared = Coordinator()
    
    private var compositionRoot: CompositionRoot {
        return CompositionRoot.sharedInstance
    }
    
    private var baseNavigationController: UINavigationController? {
        return lastPresentedViewController?.navigationController
    }
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private var lastPresentedViewController: UIViewController?
    
    private init() {}
    
    func showRootViewController() {
//        if (KeyChain.get(key: KeyConstant.userToken)) == nil || (KeyChain.get(key:  KeyConstant.userToken)) == "" {
//            showLoginViewController()
//        } else {
            showRootTabBarController()
//        }
    }

    func showLoginViewController() {
        let navController = UINavigationController(rootViewController: compositionRoot.resolveSignUpViewController())
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
    func showRootTabBarController() {
        let navController = UINavigationController(rootViewController: compositionRoot.rootTabBarController)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
    }
        
    func goToSignUpViewController() {
        push(compositionRoot.resolveSignUpViewController(), animated: true)
    }
    
    func goToUserProfileViewController() {
    }
    
    func goToMainViewController() {
        push(compositionRoot.resolveMainViewController(), animated: false)
    }

    func goToBasketViewController() {
        push(compositionRoot.resolveBasketViewController(list: [ItemBasketModel]()), animated: false)
    }

    func goToFavoriteViewController() {
        push(compositionRoot.resolveFavoritesViewController(), animated: false)
    }

    
    func goToCategoryViewController() {
        push(compositionRoot.resolveCategoryProductsViewController(), animated: false)
    }

    func goToCategoryItemsViewController(caregoryId: String, caregoryName: String) {
        push(compositionRoot.resolveCategoryItemsViewController(caregoryId: caregoryId, caregoryName: caregoryName), animated: false)
    }
    
    func goToItemDetailsViewController(id: String) {
//        push(compositionRoot.resolveItemDetailsViewController(id: id), animated: false)
        present(compositionRoot.resolveItemDetailsViewController(id: id), animated: true)
    }
    
    func push(_ vc: UIViewController, animated: Bool) {
        if let baseNavigationController = baseNavigationController {
            baseNavigationController.pushViewController(vc, animated: animated)
            lastPresentedViewController = vc
        } else {
            if let navigationController = appDelegate.window?.rootViewController as? UINavigationController {
                navigationController.pushViewController(vc, animated: animated)
            }
        }
    }
    
    func present(_ vc: UIViewController, animated: Bool) {
        if let baseNavigationController = baseNavigationController {
            baseNavigationController.present(vc, animated: animated, completion: nil)
            
//            baseNavigationController.pushViewController(vc, animated: animated)
            lastPresentedViewController = vc
        } else {
            if let navigationController = appDelegate.window?.rootViewController as? UINavigationController {
//                navigationController.pushViewController(vc, animated: animated)
                navigationController.present(vc, animated: animated, completion: nil)
            }
        }
    }

}
