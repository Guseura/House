import UIKit

class ChatsViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var mainChatBackgroundView: UIView!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainChatTitleLabel: UILabel!
    @IBOutlet weak var mainChatSubtitleLabel: UILabel!
    @IBOutlet weak var noChatsLabel: UILabel!
    @IBOutlet weak var noChatsDescriptionLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var searchChatButton: MainButton!
    
    // Image Views
    @IBOutlet weak var noChatsImage: UIImageView!
    
    // Scroll Views
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Table Views
    @IBOutlet weak var tableView: UITableView!
    
    // Constraints
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    
    var group: Group? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(tableView, with: Cell.groupCell)
        hideAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isConnectedToNetwork() ? fetchData() : fetchLocalData()
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentHeight
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        mainChatBackgroundView.roundCorners(radius: 10)
        tableView.roundCorners(radius: 10)
    }
    
    override func setupGestures() {
        mainChatBackgroundView.addTapGesture(target: self, action: #selector(groupChatTapped))
    }
    
    private func fetchData() {
        let uid = State.shared.getUserId()
        FirebaseDatabaseManager.shared.getUser(with: uid) { user in
            guard let user = user else { return }
            let isMemberEmpty = user.memberOf == ""
            self.configureChats(isMemberEmpty: isMemberEmpty)
            if !isMemberEmpty {
                FirebaseDatabaseManager.shared.getOSBB(name: user.memberOf) { group in
                    guard let group = group else { return }
                    self.group = group
                    self.mainChatTitleLabel.text = group.city + " " + group.street
                    self.mainChatSubtitleLabel.text = group.lastMessage == "" ? "No messages yet" : group.lastMessage
                    self.tableView.layoutIfNeeded()
                }
            }
        }
    }
    
    private func fetchLocalData() {
        let uid = State.shared.getUserId()
        CoreDataManager.shared.getUser(uid: uid) { user in
            guard let user = user else { return }
            self.configureChats(isMemberEmpty: user.memberOf == "")
        }
    }
    
    private func configureChats(isMemberEmpty: Bool) {
        DispatchQueue.main.async {
            self.scrollView.isHidden = isMemberEmpty
            self.noChatsImage.isHidden = !isMemberEmpty
            self.noChatsLabel.isHidden = !isMemberEmpty
            self.noChatsDescriptionLabel.isHidden = !isMemberEmpty
            self.searchChatButton.isHidden = !isMemberEmpty
        }
    }
    
    private func hideAll() {
        self.scrollView.isHidden = true
        self.noChatsImage.isHidden = true
        self.noChatsLabel.isHidden = true
        self.noChatsDescriptionLabel.isHidden = true
        self.searchChatButton.isHidden = true
    }
    
    // MARK: - Gesture actions
    
    @objc func groupChatTapped() {
        guard let group = group else { return }
        let chatViewController = ChatViewController.load(from: Main.chat)
        chatViewController.type = .group
        chatViewController.group = group
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    
    // MARK: - @IBActions
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let searchViewController = SearchViewController.load(from: Main.search)
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
}

// MARK: Extension: UITableViewDelegate, UITableViewDataSource

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let group = group else { return 0 }
        return group.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.groupCell.id, for: indexPath) as! GroupTableViewCell
        guard let group = group else { return cell }
        
        FirebaseDatabaseManager.shared.getUser(with: group.users[indexPath.row]) { user in
            guard let user = user else { return }
            DispatchQueue.main.async {
                cell.titleLabel.text = user.name
                cell.user = user
                cell.chatImageView.image = user.image
            }
            FirebaseDatabaseManager.shared.getLastMessage(uid: user.uid) { message in
                DispatchQueue.main.async {
                    cell.subtitleLabel.text = message
                    return
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! GroupTableViewCell
        let chatViewController = ChatViewController.load(from: Main.chat)
        chatViewController.type = .user
        chatViewController.user = cell.user
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
}
