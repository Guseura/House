import UIKit

class GroupTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // Image Views
    @IBOutlet weak var chatImageView: UIImageView!
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatImageView.capsuleCorners()
    }
    
}
