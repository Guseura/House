import UIKit

extension UIButton {

    public func localize(with key: String) {
        self.setTitle(localized(key), for: .normal)
    }
    
}
