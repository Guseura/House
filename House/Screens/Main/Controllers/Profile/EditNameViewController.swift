import UIKit

class EditNameViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var changeNameLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var changeButton: MainButton!
    
    // Text Fields
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Full name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextLightGray]
        )
    }
    
    // MARK: - @IBActions
    
    @IBAction func changeButtonPressed(_ sender: Any) {
        
        guard let name = nameTextField.text, name.replacingOccurrences(of: " ", with: "").count != 0 else {
            if nameTextField.canBecomeFirstResponder {
                nameTextField.becomeFirstResponder()
            }
            showDefaultAlert(title: "Name is incorrect", message: "Make sure you have entered the name.")
            return
        }
    
        FirebaseDatabaseManager.shared.updateUser(name: name) { isSuccess in
            DispatchQueue.main.async {
                if isSuccess {
                    if self.nameTextField.isFirstResponder {
                        self.nameTextField.resignFirstResponder()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

