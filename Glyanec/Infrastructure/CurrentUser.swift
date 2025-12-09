import Foundation

class CurrentUser: BaseAlert
{
    var userModel: ResultUserProfileModel?
    var redownloadVideos = true
    
//    var isInUnsignMode: Bool {
//        set
//        {
//            UserDefaults.standard.set(newValue, forKey: KeyConstant.isInUnsignMode)
//            UserDefaults.standard.synchronize()
//            
////            CompositionRoot.sharedInstance.updateProfileVCInRootTabBar()
//        }
//        get
//        {
//            return UserDefaults.standard.bool(forKey: KeyConstant.isInUnsignMode)
//        }
//    }
    
    private init() {}
    static let shared: CurrentUser = {
        let instance = CurrentUser()
//        instance.updateCurrentUserModel()
        return instance
    }()
    
    private func getUserProfile(userId: String, completion: ((Bool)->Void)? = nil) {
        LoadingSpinner.shared.startActivity()
        NetworkUserProfile.getUserProfile(userId: userId)
            .done { (responseModel) in
                LoadingSpinner.shared.stopActivity()
                self.userModel = responseModel
                completion?(true)
        }
        .catch { (error) in
            LoadingSpinner.shared.stopActivity()
            completion?(false)
            print(error)
            let message = NetworkErrorHandler.errorMessageFrom(error: error)
            self.displayErrorNotification(withText: message ?? "", sticky: false, action: nil, actionName: "Ok")
        }
    }
    
    func updateCurrentUserModel(completion: ((Bool)->Void)? = nil)
    {
        if let userID = UserAuth.userID
        {
            getUserProfile(userId: userID) { isOk in
                completion?(isOk)
            }
        }
        else
        {
            print("Can't refresh current user info")
            completion?(false)
        }
    }
}
