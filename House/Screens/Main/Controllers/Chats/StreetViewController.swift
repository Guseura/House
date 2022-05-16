import UIKit

class StreetViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var streetLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var chooseButton: MainButton!
    
    // Text Fields
    @IBOutlet weak var textField: UITextField!
    
    
    // MARK: - Variables
    
    public var completion: (_ street: String) -> () = { _ in }
    
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    // MARK: - @IBActions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseButtonPressed(_ sender: Any) {
        guard let street = textField.text, street.replacingOccurrences(of: " ", with: "").count != 0 else {
            if textField.canBecomeFirstResponder {
                textField.becomeFirstResponder()
            }
            showDefaultAlert(title: "Incorrect street", message: "Looks like you didn`t enter your street, please enter your street and try again.")
            return
        }
        completion(street)
        self.navigationController?.popViewController(animated: true)
    }
}
