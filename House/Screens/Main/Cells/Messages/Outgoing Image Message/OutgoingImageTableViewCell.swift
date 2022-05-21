import UIKit

class OutgoingImageTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var messageBackgroundView: UIView!
    
    // Labels
    @IBOutlet weak var messageTime: UILabel!
    
    // Images
    @IBOutlet weak var messageImage: UIImageView!
    
    // Constraints
    @IBOutlet weak var messageImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageBackgroundTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageImageWidthConstraint.constant = UIScreen.main.bounds.width * 2/3
        messageImage.roundCorners(radius: 5)
        messageBackgroundView.roundCorners(radius: 10)
    }
    
}
