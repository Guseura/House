import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var firstOptionView: UIView!
    @IBOutlet weak var secondOptionView: UIView!
    
    // Labels
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postSubtitleLabel: UILabel!
    @IBOutlet weak var firstOptionLabel: UILabel!
    @IBOutlet weak var firstOptionPercentLabel: UILabel!
    @IBOutlet weak var secondOptionLabel: UILabel!
    @IBOutlet weak var secondOptionPercentLabel: UILabel!
    
    // Image views
    @IBOutlet weak var firstOptionImageView: UIImageView!
    @IBOutlet weak var secondOptionImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    
    // Constraints
    @IBOutlet weak var postTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    
    var firstOptionPressedCompletion: ()->() = {}
    var secondOptionPressedCompletion: ()->() = {}
    
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.roundCorners(radius: 10)
        firstOptionView.roundCorners(radius: 5)
        secondOptionView.roundCorners(radius: 5)
        cellBackgroundView.roundCorners(radius: 10)
        
        firstOptionView.addTapGesture(target: self, action: #selector(firstOptionPressed))
        secondOptionView.addTapGesture(target: self, action: #selector(secondOptionPressed))
    
    }
    
    
    // MARK: - Gesture actions
    
    @objc private func firstOptionPressed() {
        firstOptionPressedCompletion()
    }
    
    @objc private func secondOptionPressed() {
        secondOptionPressedCompletion()
    }
    
}
