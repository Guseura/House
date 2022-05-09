import UIKit

public enum Main: String, StoryboardScreen {
    
    case main = "MainViewController"

    
}

extension Main {
    
    public var location: Storyboard { return .Main }
    public var id: String { return self.rawValue }
    public var storyboard: UIStoryboard {
        return UIStoryboard(name: self.location.rawValue, bundle: nil)
    }
    
}
