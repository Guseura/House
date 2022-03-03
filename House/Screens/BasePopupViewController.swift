import UIKit

class BasePopupViewController: BaseViewController {
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        self.view.backgroundColor = .clear
        self.view.insertSubview(blurredEffectView, at: 0)
    }
    
}
