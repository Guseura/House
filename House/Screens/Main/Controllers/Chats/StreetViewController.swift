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
    
    
    // MARK: - Custom functions
    
    override func localize() {
        streetLabel.localize(with: "create.group.street")
        chooseButton.localize(with: "street.choose")
        textField.placeholder = localized("create.group.street")
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
            showDefaultAlert(title: localized("street.error.title"), message: localized("street.error.descr"))
            return
        }
        completion(street)
        self.navigationController?.popViewController(animated: true)
    }
}
