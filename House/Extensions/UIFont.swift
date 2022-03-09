import UIKit

extension UIFont {

    // MARK: - Avenir Font
    
    class Avenir: UIFont {
        
        public static func black(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirLTStd-Black", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        public static func book(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirLTStd-Book", size: size) ?? UIFont.systemFont(ofSize: size)
        }

        public static func roman(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirLTStd-Roman", size: size) ?? UIFont.systemFont(ofSize: size)
        }

    }
    
    
    // MARK: - Circular Font
    
    class CircularStd: UIFont {
        
        public static func black(size: CGFloat) -> UIFont {
            return UIFont(name: "CircularStd-Black", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        public static func bold(size: CGFloat) -> UIFont {
            return UIFont(name: "CircularStd-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        public static func book(size: CGFloat) -> UIFont {
            return UIFont(name: "CircularStd-Book", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        public static func medium(size: CGFloat) -> UIFont {
            return UIFont(name: "CircularStd-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
    }
    
}
