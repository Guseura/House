import UIKit

class LoadingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if State.shared.isNotFirstLaunch() {
            let viewController = State.shared.isLoggedIn() ? UITabBarController.load(from: Main.tabBar) : UINavigationController.load(from: Authorization.authNavigation)
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        } else {
            State.shared.setIsNotFirstLaunch()
            let viewController = OnboardingViewController.load(from: Authorization.onboarding)
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }

}
