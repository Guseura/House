import UIKit

public enum Cell: String {
    
    case onboardingCell = "OnboardingCollectionViewCell"
    case settingsCell   = "SettingsTableViewCell"
    case languageCell   = "LanguageTableViewCell"
    case searchCell     = "SearchTableViewCell"
    case groupCell      = "GroupTableViewCell"
    case incoming       = "IncomingMessageTableViewCell"
    case outgoing       = "OutgoingMessageTableViewCell"
    case post           = "PostTableViewCell"
    
}

extension Cell {
    var id: String {
        return self.rawValue
    }
    
    var nib: UINib {
        return UINib(nibName: self.id, bundle: nil)
    }
}
