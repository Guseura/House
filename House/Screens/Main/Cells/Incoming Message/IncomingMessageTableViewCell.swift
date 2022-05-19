import UIKit

class IncomingMessageTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageTimeLabel: UILabel!
    @IBOutlet weak var messageUsernameLabel: UILabel!
    
    // Views
    @IBOutlet weak var messageBackgroundView: UIView!
    
    // Images
    @IBOutlet weak var messageSenderImage: UIImageView!
    
    // Constraints
    @IBOutlet weak var messageBackgroundTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackgroundView.roundCorners(radius: 10)
        messageSenderImage.capsuleCorners()
    }
    
    
    // MARK: - Custom functions
    
    public func configureWithoutImage() {
        messageSenderImage.isHidden = true
    }
    
}
