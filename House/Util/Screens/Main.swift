import UIKit

public enum Main: String, StoryboardScreen {
    
    // Tab Bar
    case tabBar     = "TabBarController"
    
    // Main
    case main       = "MainViewController"
    
    // Chats
    case chats    = "ChatsViewController"
    
    // Profile
    case profile    = "ProfileViewController"
    case editName   = "EditNameViewController"
    case editImage  = "EditImageViewController"
    case language   = "LanguageViewController"
    
}

extension Main {
    
    public var location: Storyboard { return .Main }
    public var id: String { return self.rawValue }
    public var storyboard: UIStoryboard {
        return UIStoryboard(name: self.location.rawValue, bundle: nil)
    }
    
}
