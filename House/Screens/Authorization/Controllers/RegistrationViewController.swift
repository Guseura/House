import UIKit

class RegistrationViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var createAccountLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Constraints
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotifications()
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        configureTextFields()
    }
    
    private func configureTextFields() {
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Full name",    // Localized Full name
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextLightGray]
        )
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",        // Localized Email
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextLightGray]
        )
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",    // Localized Password
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextLightGray]
        )
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - @objc functions
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            DispatchQueue.main.async {
                self.bottomConstraint.constant = keyboardFrame.cgRectValue.height + 12 - safeAreaBottomInset
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            self.bottomConstraint.constant = 28
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - @IBActions
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        // Check the fields
        
        guard let name = nameTextField.text, name.replacingOccurrences(of: " ", with: "").count != 0 else {
            if nameTextField.canBecomeFirstResponder {
                nameTextField.becomeFirstResponder()
            }
            showDefaultAlert(title: "Name is incorrect", message: "Make sure you have entered the name.")
            return
        }
        
        guard let email = emailTextField.text, email.isValidEmail() else {
            if emailTextField.canBecomeFirstResponder {
                emailTextField.becomeFirstResponder()
            }
            showDefaultAlert(title: "Email is incorrect", message: "Make sure you have entered the correct email.")
            return
        }
        
        guard let password = passwordTextField.text, password.count >= 8, password.isValidPassword() else {
            if passwordTextField.canBecomeFirstResponder {
                passwordTextField.becomeFirstResponder()
            }
            showDefaultAlert(title: "Password is incorrect", message: "Make sure that the password does not contain forbidden characters and is longer than 7 characters")
            return
        }
        
        // Request
        
        UserNetwork.shared.addUser(name: name, email: email, password: password, image: "image") { userCreationResult in
            
            switch userCreationResult {
            case .success(let response):
                if response.status == true {
                    guard let id = response.id else { return }
                    DispatchQueue.main.async {
                        UserCoreDataManager.shared.saveUser(id: id, name: name, email: email, image: "image") { _ in
                            DispatchQueue.main.async {
                                State.shared.setIsLoggedIn(to: true)
                                State.shared.setUserId(to: id)
                                let mainTabBarController = UITabBarController.load(from: Main.tabBar)
                                mainTabBarController.modalPresentationStyle = .fullScreen
                                self.present(mainTabBarController, animated: true, completion: nil)
                            }
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.showDefaultAlert(title: "Already registered", message: response.message)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func authorizationButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
