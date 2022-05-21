import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var cellBackgroundView: UIView!
    
    // Labels
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postLikesLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var likeButton: UIButton!
    
    // Image views
    @IBOutlet weak var postImageView: UIImageView!
    
    // Constraints
    @IBOutlet weak var postTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    
    public var onLikeButtonPressed: () -> () = {}
    
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.roundCorners(radius: 10)
        postImageView.roundCorners(radius: 10, corners: .topLeft, .topRight)
    }
    
    
    // MARK: - @IBActions
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        onLikeButtonPressed()
    }
    
    
}
