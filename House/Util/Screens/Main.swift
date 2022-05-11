import UIKit

public enum Main: String, StoryboardScreen {
    
    case tabBar = "TabBarController"
    case main       = "MainViewController"
    case dialogs    = "DialogsViewController"
    case profile    = "ProfileViewController"

    
}

extension Main {
    
    public var location: Storyboard { return .Main }
    public var id: String { return self.rawValue }
    public var storyboard: UIStoryboard {
        return UIStoryboard(name: self.location.rawValue, bundle: nil)
    }
    
}
