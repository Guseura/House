import UIKit

class OutgoingMessageTableViewCell: UITableViewCell {
    
    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    
    // Views
    @IBOutlet weak var messageBackgroundView: UIView!
    
    // Constraints
    @IBOutlet weak var messageBackgroundTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackgroundView.roundCorners(radius: 10)
    }
    
}
