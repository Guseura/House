import UIKit

class SearchTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityStreetLabel: UILabel!
    @IBOutlet weak var usersLabel: UILabel!
    
    // Views
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - Custom functions
    
    public func cornerTopCorners() {
        contentView.roundCorners(radius: 10, corners: .topLeft, .topRight)
    }
    
    public func cornerBottomCorners() {
        contentView.roundCorners(radius: 10, corners: .bottomLeft, .bottomRight)
    }
    
    public func cornerAllCorners() {
        contentView.roundCorners(radius: 10)
    }

    
}
