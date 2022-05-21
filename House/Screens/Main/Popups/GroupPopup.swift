import UIKit

class GroupPopup: BasePopupViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Views
    @IBOutlet weak var popupBackgroundView: UIView!
    
    // Buttons
    @IBOutlet weak var createButton: MainButton!
    @IBOutlet weak var cancelButton: SecondaryButton!
    
    var completion: ((Bool)->()) = { _ in }
    
    // MARK: - Awake function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateIn()
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        titleLabel.localize(with: "popup.title")
        descriptionLabel.localize(with: "popup.descr")
        createButton.localize(with: "popup.create")
        cancelButton.localize(with: "popup.cancel")
    }
    
    override func configureUI() {
        popupBackgroundView.roundCorners(radius: 10)
    }
    
    func animateIn() {
        self.view.alpha = 0
        popupBackgroundView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.4, options: .curveEaseIn) {
            self.tabBarController?.tabBar.isHidden = true
            self.view.alpha = 1
            self.popupBackgroundView.transform = .identity
        }
    }
    
    func animateOut() {
        self.view.alpha = 1
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.4, options: .curveEaseIn) {
            self.view.alpha = 0
            self.popupBackgroundView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            self.tabBarController?.tabBar.isHidden = false
        } completion: { completed in
            self.view.removeFromSuperview()
        }
    }
    
    // MARK: - @IBActions
    
    @IBAction func createButtonPressed(_ sender: Any) {
        completion(true)
        animateOut()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        completion(false)
        animateOut()
    }
    
}
