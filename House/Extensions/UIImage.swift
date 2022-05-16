import UIKit

extension UIImage {
    
    internal enum Icons {
        
        public static let back      = UIImage(named: "Back Icon") ?? UIImage()
        public static let close     = UIImage(named: "Close Icon") ?? UIImage()
        public static let lock      = UIImage(named: "Lock Icon") ?? UIImage()
        public static let mail      = UIImage(named: "Mail Icon") ?? UIImage()
        public static let scan      = UIImage(named: "Scan Icon") ?? UIImage()
        public static let user      = UIImage(named: "User Icon") ?? UIImage()
        public static let avatar    = UIImage(named: "Avatar Icon") ?? UIImage()
        public static let checked   = UIImage(named: "Checked Icon") ?? UIImage()
        public static let unchecked = UIImage(named: "Unchecked Icon") ?? UIImage()
        public static let groupIcon = UIImage(named: "Group Icon") ?? UIImage()
        
    }
    
    internal enum Onboarding {
        
        public static let first     = UIImage(named: "onboarding-1") ?? UIImage()
        public static let second    = UIImage(named: "onboarding-2") ?? UIImage()
        public static let third     = UIImage(named: "onboarding-3") ?? UIImage()
        
    }
    
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

}
