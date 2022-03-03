import UIKit

extension UILabel {
    
    public func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
    
    public func contentHeight(lineSpacing: CGFloat) -> CGFloat {
        self.setLineHeight(lineHeight: lineSpacing)
        self.sizeToFit()
        return self.frame.height
    }
    
    public func localize(with key: String) {
        self.text = localized(key)
    }
    
}
