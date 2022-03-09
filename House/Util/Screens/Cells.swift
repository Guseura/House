import UIKit

public enum Cell: String {
    
    case onboardingCell = "OnboardingCollectionViewCell"
    
}

extension Cell {
    var id: String {
        return self.rawValue
    }
    
    var nib: UINib {
        return UINib(nibName: self.id, bundle: nil)
    }
}
