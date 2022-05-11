import UIKit

class AuthorizationViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Text Fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - @IBActions
    
    
    @IBAction func authorizationButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        UserNetwork.shared.getUser(email: email, password: password) { result in
            
            switch result {
            
            case .success(let user):
                DispatchQueue.main.async {
                    UserCoreDataManager.shared.saveUser(id: user.id, name: user.name, email: user.email, image: "image") { _ in
                        DispatchQueue.main.async {
                            State.shared.setIsLoggedIn(to: true)
                            State.shared.setUserId(to: user.id)
                            let mainTabBarController = UITabBarController.load(from: Main.tabBar)
                            mainTabBarController.modalPresentationStyle = .fullScreen
                            self.present(mainTabBarController, animated: true, completion: nil)
                        }
                    }
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self.showDefaultAlert(title: "Not found", message: "Check that your email and password have been entered correctly and try again")
                }
            }
        }
    }
    
    @IBAction func registrationButtonPressed(_ sender: Any) {
        let registrationViewController = RegistrationViewController.load(from: Authorization.registration)
        self.navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
}
