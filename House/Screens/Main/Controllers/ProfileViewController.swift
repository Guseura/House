import UIKit

class ProfileViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    // Image Views
    @IBOutlet weak var userImageView: UIImageView!
    
    // Table Views
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var appTableView: UITableView!
    @IBOutlet weak var otherTableView: UITableView!
    
    // Constraints
    @IBOutlet weak var profileTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var appTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherTableViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(profileTableView, with: Cell.settingsCell)
        configure(appTableView, with: Cell.settingsCell)
        configure(otherTableView, with: Cell.settingsCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    override func viewDidLayoutSubviews() {
        profileTableViewHeightConstraint.constant = profileTableView.contentHeight
        appTableViewHeightConstraint.constant = appTableView.contentHeight
        otherTableViewHeightConstraint.constant = otherTableView.contentHeight
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        userImageView.capsuleCorners()
        profileTableView.roundCorners(radius: 10)
        appTableView.roundCorners(radius: 10)
        otherTableView.roundCorners(radius: 10)
    }
    
    private func fetchUser() {
        let userId = State.shared.getUserId()
        UserNetwork.shared.getUser(id: userId) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.userNameLabel.text = user.name
                    self.userEmailLabel.text = user.email
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case profileTableView:
            return State.shared.profileSettings.count
        case appTableView:
            return State.shared.appSettings.count
        case otherTableView:
            return State.shared.otherSettings.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.settingsCell.id, for: indexPath) as! SettingsTableViewCell
        
        switch tableView {
        case profileTableView:
            cell.cellLabel.text = State.shared.profileSettings[indexPath.row]
        case appTableView:
            cell.cellLabel.text = State.shared.appSettings[indexPath.row]
        case otherTableView:
            cell.cellLabel.text = State.shared.otherSettings[indexPath.row]
        default:
            ()
        }
    
        return cell
    }
    
    
}

