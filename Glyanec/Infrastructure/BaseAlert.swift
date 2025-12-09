import SwiftMessages
import UIKit

protocol BaseAlert: class {
    func displayErrorNotification(withText text: String, sticky: Bool, action: (() -> Void)?, actionName: String?)
    func displayWarningNotification(withText text: String, sticky: Bool, action: (() -> Void)?, actionName: String?)
    func displayInformationNotification(withText text: String, withTitle title: String, sticky: Bool, action: (() -> Void)?, actionName: String?)
}

extension BaseAlert {
    func displayErrorNotification(withText text: String,
                                  sticky: Bool,
                                  action: (() -> Void)?,
                                  actionName: String?) {
        let error = MessageView.viewFromNib(layout: .cardView)
        error.configureTheme(.error)
        error.configureDropShadow()
        error.configureContent(title: "Error", body: text)
        error.button?.isHidden = action == nil
        error.buttonTapHandler = { _ in
            SwiftMessages.hide(id: text)
            action?()
        }
        error.button?.setTitle(actionName, for: .normal)
        var errorConfig = SwiftMessages.defaultConfig
        errorConfig.duration = sticky ? .forever : .automatic
        errorConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        error.id = text
        SwiftMessages.show(config: errorConfig, view: error)
    }

    func displayWarningNotification(withText text: String,
                                    sticky: Bool,
                                    action: (() -> Void)?,
                                    actionName: String?) {
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
//        warning.configureContent(title: L10n.App.Notification.Error.title, body: text)
        warning.button?.isHidden = action == nil
        warning.buttonTapHandler = { _ in
            SwiftMessages.hide(id: text)
            action?()
        }
        warning.button?.setTitle(actionName, for: .normal)
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.duration = sticky ? .forever : .automatic
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        warning.id = text
        SwiftMessages.show(config: warningConfig, view: warning)
    }

    func displayInformationNotification(withText text: String,
                                        withTitle title: String = "L10n.App.Notification.Info.title",
                                        sticky: Bool,
                                        action: (() -> Void)?,
                                        actionName: String?) {
        let info = MessageView.viewFromNib(layout: .cardView)
        info.configureTheme(.info)
        info.configureDropShadow()
        info.configureContent(title: title, body: text)
        info.button?.isHidden = action == nil
        info.buttonTapHandler = { _ in
            SwiftMessages.hide(id: text)
            action?()
        }
        info.button?.setTitle(actionName, for: .normal)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.duration = sticky ? .forever : .automatic
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        info.id = text
        SwiftMessages.show(config: infoConfig, view: info)
    }
}
