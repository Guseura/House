import UIKit

extension UIFont {

    // MARK: - Avenir Font
    
    public enum AvenirWeight {
        case black
        case book
        case roman
    }
    
    public static func avenirFont(ofSize size: CGFloat, weight: AvenirWeight) -> UIFont {
        
        var avenirWeight: String = "Book"
        
        switch weight {
        
        case .black:
            avenirWeight = "Black"
        case .book:
            avenirWeight = "Book"
        case .roman:
            avenirWeight = "Roman"
            
        }
        
        return UIFont(name: "AvenirLTStd-\(avenirWeight)", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    
    // MARK: - Circular Font
    
    public enum CircularWeight {
        case black
        case bold
        case book
        case medium
    }
    
    public static func circularFont(ofSize size: CGFloat, weight: CircularWeight) -> UIFont {
        
        var circularWeight: String = "Book"
        
        switch weight {
        
        case .black:
            circularWeight = "Black"
        case .bold:
            circularWeight = "Bold"
        case .book:
            circularWeight = "Book"
        case .medium:
            circularWeight = "Medium"
        
        }
        
        return UIFont(name: "CircularStd-\(circularWeight)", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
}
