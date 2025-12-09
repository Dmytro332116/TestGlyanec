import UIKit
import PhoneNumberKit
import ActiveLabel

protocol LogInViewProtocol {
    func showLocationAlert(_ alertController: UIAlertController)
}

class LogInViewController: BaseViewController<LogInViewModel>, LogInViewProtocol {

    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var title3Label: ActiveLabel! {
        didSet {
            let customType = ActiveType.custom(pattern: "\\оферты\\b") //Regex that looks for "with"
            title3Label.enabledTypes = [customType]
            title3Label.text = "Нажимая кнопку “Войти” вы соглашаетесь с условиями оферты"
            title3Label.customColor[customType] = UIColor.init(hexString: "2f749d")
                
            title3Label.handleCustomTap(for: customType) { element in
                print("Custom type tapped: \(element)")
            }
        }
    }
    
    @IBOutlet weak var codePrefixLabel: UILabel!

    @IBOutlet weak var phoneTextField: PhoneNumberTextField! {
        didSet {
            phoneTextField.delegate = self
            phoneTextField.withPrefix = false
            phoneTextField.withExamplePlaceholder = true
            
            codePrefixLabel.text = "+"+"\(viewModel.getCountryPhonceCode(country: phoneTextField.currentRegion))"
        }
    }
    
    
    

    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupButtonLayer()
        
        if #available(iOS 17.6, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        viewModel.showLocationPermission()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 150
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    override func bindWithObserver() {
        observer.from(phoneTextField, \.text, forName: UITextField.textDidChangeNotification).to(viewModel, \.phone)
    }
    
    func updateState(textString: String, isEnable: Bool) {
    }
    
    func isActiveButtonLogin() {
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.borderWidth = 2.0
        signUpButton.layer.borderColor = UIColor.white.cgColor
    }

    private func setupButtonLayer() {
        isActiveButtonLogin()
    }
    
    func showLocationAlert(_ alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        return result
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
//        if validate(value: phoneTextField.text!) == true {
        
        let text = String(format: "%@%@", codePrefixLabel.text!, phoneTextField.text!)
        let phone = String(text.filter { !" \n\t\r".contains($0) })
        
        viewModel.signup(phone: phone)
//        } else {
//            viewModel.phoneError()
//            phoneTextField.text = ""
//        }
    }
}

extension LogInViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
