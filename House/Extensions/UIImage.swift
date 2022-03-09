import UIKit

extension UIImage {

    public static var isDarkMode = false
    
    internal enum Icons {
        
        public static let back          = UIImage(named: "") ?? UIImage()
        
    }
    
    internal enum Onboarding {
        
        public static let first     = (isDarkMode ? UIImage(named: "dark-onboarding-1") : UIImage(named: "white-onboarding-1")) ?? UIImage()
        public static let second    = (isDarkMode ? UIImage(named: "dark-onboarding-2") : UIImage(named: "white-onboarding-2")) ?? UIImage()
        public static let third     = (isDarkMode ? UIImage(named: "dark-onboarding-3") : UIImage(named: "white-onboarding-3")) ?? UIImage()
        
    }

}
