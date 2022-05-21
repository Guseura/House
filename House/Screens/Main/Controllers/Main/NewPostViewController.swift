import UIKit

class NewPostViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var createButton: MainButton!
    
    // Image views
    @IBOutlet weak var postImageView: UIImageView!
    
    // Text Fields
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // Constraints
    @IBOutlet weak var createButtonBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    
    public var user: User!
    private var isImageChanged: Bool = false
    
    
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
        postImageView.roundCorners(radius: 10)
        configureTextFields()
    }
    
    override func setupGestures() {
        postImageView.addTapGesture(target: self, action: #selector(imageViewTapped))
    }
    
    private func configureTextFields() {
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "Title",    // Localized Title
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextLightGray]
        )
        
        descriptionTextField.attributedPlaceholder = NSAttributedString(
            string: "Description",    // Localized Description
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
                self.createButtonBottomConstraint.constant = keyboardFrame.cgRectValue.height + 12 - safeAreaBottomInset
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            self.createButtonBottomConstraint.constant = 28
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    // MARK: - Gesture actions
    
    @objc private func imageViewTapped() {
        ImagePickerManager.shared.pickImage(self) { image in
            DispatchQueue.main.async {
                self.isImageChanged = true
                self.postImageView.image = image
            }
        }
    }
    
    
    // MARK: - @IBActions
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        guard let titleText = titleTextField.text, titleText.replacingOccurrences(of: " ", with: "").count != 0 else {
            if titleTextField.canBecomeFirstResponder {
                titleTextField.becomeFirstResponder()
            }
            showDefaultAlert(title: "Incorrect title", message: "Looks like you didn`t enter title, please enter title and try again.")
            return
        }
        
        guard let descriptionText = descriptionTextField.text, descriptionText.replacingOccurrences(of: " ", with: "").count != 0 else {
            if descriptionTextField.canBecomeFirstResponder {
                descriptionTextField.becomeFirstResponder()
            }
            showDefaultAlert(title: "Incorrect description", message: "Looks like you didn`t enter description, please enter description and try again.")
            return
        }
        
        if isImageChanged {
            guard let image = postImageView.image else { return }
            FirebaseDatabaseManager.shared.addPost(groupName: self.user.memberOf, image: image, titleText: titleText, subtitleText: descriptionText) { [weak self] isAdded in
                guard let strongSelf = self else { return }
                if isAdded {
                    strongSelf.navigationController?.popViewController(animated: true)
                } else {
                    strongSelf.showDefaultAlert(title: "Something went wrong", message: "Try again later...")
                }
            }
        } else {
            FirebaseDatabaseManager.shared.addPost(groupName: self.user.memberOf, titleText: titleText, subtitleText: descriptionText) { [weak self] isAdded in
                guard let strongSelf = self else { return }
                if isAdded {
                    strongSelf.navigationController?.popViewController(animated: true)
                } else {
                    strongSelf.showDefaultAlert(title: "Something went wrong", message: "Try again later...")
                }
            }
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
