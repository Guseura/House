import UIKit

class MainButton: UIButton {
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        configureUI()
    }
    
    // MARK: - Custom functions
    
    private func configureUI() {
        roundCorners(radius: 10)
        backgroundColor = UIColor.BAccentColor
        setTitleColor(UIColor.TMainColor, for: .normal)
        titleLabel?.font = UIFont.CircularStd.bold(size: 20)
    }
    
}
