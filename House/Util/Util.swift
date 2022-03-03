import UIKit
import SystemConfiguration

public func getAlert(title: String?, message: String? = nil, actions: UIAlertAction...) -> UIAlertController {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions.forEach { action in
        alert.addAction(action)
    }
    
    return alert
    
}

public func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
    }
    
    // Working for Cellular and WIFI
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let isConnected = (isReachable && !needsConnection)
    
    return isConnected
    
}

public func localized(_ key: String) -> String {
    let path = Bundle.main.path(forResource: State.shared.getLanguageCode().rawValue, ofType: "lproj")
    let bundle = Bundle(path: path!) ?? Bundle.main
    let format = bundle.localizedString(forKey: key, value: nil, table: nil)
    return String(format: format)
}


