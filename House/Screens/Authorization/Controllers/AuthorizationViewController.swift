import UIKit

class AuthorizationViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Views
    // Labels
    // Buttons
    // Image Views
    
    // Text Fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Variables
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
        setupGestures()
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        configureTextFields()
    }
    
    private func configureTextFields() {
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",    // Localized Email
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.TLightGray]
        )
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",    // Localized Password
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.TLightGray]
        )
    }
    
    override func setupGestures() {
        
    }
    
    // MARK: - Gesture actions
    
    // MARK: - @IBActions
    
}
