import Foundation
import UIKit

class LoadingSpinner {
    
    static let shared = LoadingSpinner()
    private var loadingView: CustomActivityView?
    
    func startActivity() {
        
        if loadingView != nil {
        }
        
        loadingView?.removeFromSuperview()
        loadingView = CustomActivityView(frame: UIScreen.main.bounds)
        
        if let delegate = UIApplication.shared.delegate, let window = delegate.window, let vc = window?.rootViewController {
            guard let v = loadingView else { return }
            vc.view.addSubview(v)
            v.isHidden = false
            v.startActivityIndicator()
        }
    }
    
    func stopActivity() {
        loadingView?.isHidden = true
        loadingView?.stopActivityIndicator()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
}
