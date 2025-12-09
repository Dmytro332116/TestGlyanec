import UIKit

class BaseViewController<T>: UIViewController, BaseAlert where T: ViewModel {
    
    var loadingView: CustomActivityView?
    var observer = Observer()
    var viewModel: T!

    public override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        setNeedsStatusBarAppearanceUpdate()
        viewModel.viewDidLoad()
        setupTapGesture()
        
        if #available(iOS 12.0, *) {
            CompositionRoot.sharedInstance.updateUI(style: traitCollection.userInterfaceStyle)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 12.0, *) {
            CompositionRoot.sharedInstance.updateUI(style: traitCollection.userInterfaceStyle)
        }
    }

    func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func showActivityIndicator() {
        if loadingView == nil {
            loadingView = CustomActivityView(frame: UIScreen.main.bounds)
            self.view.addSubview(loadingView!)
            loadingView?.startActivityIndicator()
            return
        } else {
            loadingView!.startActivityIndicator()
        }
        loadingView?.isHidden = false
    }
    
    func hideActivityIndicator() {
        loadingView?.stopActivityIndicator()
        loadingView?.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        //return .lightContent
        return .default

    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindWithObserver()
        viewModel.viewWillAppear()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
        observer.invalidateAll()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }

    @objc func willEnterForeground() {
        viewModel.willEnterForeground()
    }

    @objc func didEnterBackground() {
        viewModel.didEnterBackground()
    }

    func bindWithObserver() {}

    func set(viewModel: T) {
        self.viewModel = viewModel
    }
    
    func showNavigation(isHidden: Bool) {
        navigationController?.navigationBar.isHidden = isHidden
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorCompatibility.label]
//        navigationController?.navigationBar.tintColor = ColorCompatibility.label;
        navigationController?.navigationBar.isTranslucent = true
    }

}
