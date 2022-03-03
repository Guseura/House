import UIKit

let userDefaults = UserDefaults.standard

enum UDKeys {
    static let language: String                 = "language"
}

public var safeAreaBottomInset: CGFloat {
    let window = UIApplication.shared.windows.first
    let bottomPadding = window!.safeAreaInsets.bottom
    return bottomPadding
}
