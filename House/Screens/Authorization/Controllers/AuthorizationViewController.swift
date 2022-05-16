import UIKit
import FirebaseAuth

class AuthorizationViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var welcomeBackLabel: UILabel!
    
    // Text Fields
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
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",    // Localized Email
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
    
    @IBAction func authorizationButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard authResult != nil, error == nil else {
                self.showDefaultAlert(title: "Not found", message: "There is no user with such email and password, please check your data and try again.")
                return
            }
            
            guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
            FirebaseDatabaseManager.shared.getUser(with: uid) { user in
                guard let user = user else { return }
                CoreDataManager.shared.saveUser(uid: uid, name: user.name, email: user.email, image: user.image, memberOf: user.memberOf) { _ in
                    State.shared.setIsLoggedIn(to: true)
                    State.shared.setUserId(to: uid)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func registrationButtonPressed(_ sender: Any) {
        let registrationViewController = RegistrationViewController.load(from: Authorization.registration)
        self.navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
}
