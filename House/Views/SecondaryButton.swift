import UIKit

class SecondaryButton: UIButton {
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        configureUI()
    }
    
    // MARK: - Custom functions
    
    private func configureUI() {
        roundCorners(radius: 10)
        setBorder(width: 1, color: UIColor.TLightGray)
        setTitleColor(UIColor.TLightGray, for: .normal)
        titleLabel?.font = UIFont.circularFont(ofSize: 20, weight: .bold)
    }
    
}