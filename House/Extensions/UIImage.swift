import UIKit

extension UIImage {
    
    internal enum Icons {
        
        public static let back      = UIImage(named: "Back Icon") ?? UIImage()
        public static let close     = UIImage(named: "Close Icon") ?? UIImage()
        public static let lock      = UIImage(named: "Lock Icon") ?? UIImage()
        public static let mail      = UIImage(named: "Mail Icon") ?? UIImage()
        public static let scan      = UIImage(named: "Scan Icon") ?? UIImage()
        public static let user      = UIImage(named: "User Icon") ?? UIImage()
        
    }
    
    internal enum Onboarding {
        
        public static let first     = UIImage(named: "onboarding-1") ?? UIImage()
        public static let second    = UIImage(named: "onboarding-2") ?? UIImage()
        public static let third     = UIImage(named: "onboarding-3") ?? UIImage()
        
    }

}
