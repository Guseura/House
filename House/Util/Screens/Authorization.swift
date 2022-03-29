import UIKit

public enum Authorization: String, StoryboardScreen {
    
    case onboarding     = "OnboardingViewController"
    case authorization  = "AuthorizationViewController"

    
}

extension Authorization {
    
    public var location: Storyboard { return .Authorization }
    public var id: String { return self.rawValue }
    public var storyboard: UIStoryboard {
        return UIStoryboard(name: self.location.rawValue, bundle: nil)
    }
    
}
