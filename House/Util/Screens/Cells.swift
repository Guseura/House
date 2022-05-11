import UIKit

public enum Cell: String {
    
    case onboardingCell = "OnboardingCollectionViewCell"
    case settingsCell   = "SettingsTableViewCell"
    
}

extension Cell {
    var id: String {
        return self.rawValue
    }
    
    var nib: UINib {
        return UINib(nibName: self.id, bundle: nil)
    }
}
