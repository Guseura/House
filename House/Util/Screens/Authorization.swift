import UIKit

public enum Authorization: String, StoryboardScreen {
    
    case loading        = "LoadingViewController"
    case onboarding     = "OnboardingViewController"
    case authNavigation = "AuthorizationNavigationController"
    case authorization  = "AuthorizationViewController"
    case registration   = "RegistrationViewController"

}

extension Authorization {
    
    public var location: Storyboard { return .Authorization }
    public var id: String { return self.rawValue }
    public var storyboard: UIStoryboard {
        return UIStoryboard(name: self.location.rawValue, bundle: nil)
    }
    
}
