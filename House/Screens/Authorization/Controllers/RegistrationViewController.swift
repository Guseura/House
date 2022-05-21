import UIKit
import FirebaseAuth

class RegistrationViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var createAccountLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var signUpButton: MainButton!
    @IBOutlet weak var loginButton: SecondaryButton!
    
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
    
    override func localize() {
        createAccountLabel.localize(with: "registration.create")
        loginButton.localize(with: "login")
        signUpButton.localize(with: "signup")
        orLabel.localize(with: "or")
    }
    
    override func configureUI() {
        configureTextFields()
    }
    
    private func configureTextFields() {
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: localized("registration.fullname"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextLightGray]
        )
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: localized("email"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextLightGray]
        )
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: localized("password"),
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
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            self.bottomConstraint.constant = 28
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
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
            showDefaultAlert(title: localized("Incorrect name"), message: localized("registration.error.name.descr"))
            return
        }
        
        guard let email = emailTextField.text, email.isValidEmail() else {
            if emailTextField.canBecomeFirstResponder {
                emailTextField.becomeFirstResponder()
            }
            showDefaultAlert(title: localized("registration.error.email.title"), message: localized("registration.error.email.descr"))
            return
        }
        
        guard let password = passwordTextField.text, password.count >= 8, password.isValidPassword() else {
            if passwordTextField.canBecomeFirstResponder {
                passwordTextField.becomeFirstResponder()
            }
            showDefaultAlert(title: localized("registration.error.password.title"), message: localized("registration.error.password.descr"))
            return
        }
            
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard error == nil else {
                self.showDefaultAlert(title: localized("registration.error.user.exist.title"), message: localized("registration.error.user.exist.descr"))
                return
            }
            
            let uid = FirebaseAuth.Auth.auth().currentUser?.uid ?? ""
            let user = User(uid: uid, name: name, email: email, image: UIImage.Icons.avatar, memberOf: "")
            FirebaseDatabaseManager.shared.insertUser(with: user)
            
            CoreDataManager.shared.saveUser(uid: uid, name: name, email: email, image: UIImage.Icons.avatar, memberOf: "") { isSaved in
                State.shared.setIsLoggedIn(to: true)
                State.shared.setUserId(to: uid)
                self.dismiss(animated: true, completion: nil)
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
