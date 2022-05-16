import UIKit

public enum Popup: String, StoryboardScreen {
    
    case groupPopup = "GroupPopup"
    
}

extension Popup {
    
    public var location: Storyboard { return .Main }
    public var id: String { return self.rawValue }
    public var storyboard: UIStoryboard {
        return UIStoryboard(name: self.location.rawValue, bundle: nil)
    }
    
}
