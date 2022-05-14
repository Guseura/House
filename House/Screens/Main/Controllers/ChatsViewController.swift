import UIKit

class ChatsViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Views
    // Labels
    // Buttons
    // Image Views
    // ...
    
    // MARK: - Variables
    
    var chats: [Any] = []
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(chats.count == 0, animated: false)
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        
    }
    
    // MARK: - @IBActions
    
}
