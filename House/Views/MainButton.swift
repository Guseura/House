import UIKit

class MainButton: UIButton {
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        configureUI()
    }
    
    // MARK: - Custom functions
    
    private func configureUI() {
        roundCorners(radius: 10)
        backgroundColor = UIColor.BackgroundAccentColor
        setTitleColor(UIColor.TextButtonColor, for: .normal)
        titleLabel?.font = UIFont.circularFont(ofSize: 20, weight: .bold)
    }
    
}
