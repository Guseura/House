import UIKit

class IncomingImageTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var messageTimeLabel: UILabel!
    @IBOutlet weak var messageUsernameLabel: UILabel!
    
    // Views
    @IBOutlet weak var messageBackgroundView: UIView!
    
    // Images
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageSenderImage: UIImageView!
    
    // Constraints
    @IBOutlet weak var messageImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageBackgroundTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageImageWidthConstraint.constant = UIScreen.main.bounds.width * 2/3
        messageImage.roundCorners(radius: 5)
        messageBackgroundView.roundCorners(radius: 10)
        messageSenderImage.capsuleCorners()
    }
    
    
    // MARK: - Custom functions
    
    public func configureWithoutImage() {
        messageSenderImage.isHidden = true
    }
}
