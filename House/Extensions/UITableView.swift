import UIKit

extension UITableView {
    
    func registerCell(cell: Cell) {
        self.register(cell.nib, forCellReuseIdentifier: cell.rawValue)
    }
    
    public var contentHeight: CGFloat {
        self.layoutIfNeeded()
        return self.contentSize.height
    }
    
}
