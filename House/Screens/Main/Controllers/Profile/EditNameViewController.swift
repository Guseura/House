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
    
        UserNetwork.shared.updateUser(name: name, id: State.shared.getUserId()) { result in
            switch result {
            
            case .success(_):
                DispatchQueue.main.async {
                    self.showDefaultAlert(title: "Success!", message: "Your name has been successfully changed")
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

