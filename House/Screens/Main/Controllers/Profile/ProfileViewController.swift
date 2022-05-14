import UIKit
import FirebaseAuth

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
        isConnectedToNetwork() ? fetchUser() : fetchLocalUser()
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
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
        FirebaseDatabaseManager.shared.getUser(with: uid) { user in
            guard let user = user else { return }
            DispatchQueue.main.async {
                self.userNameLabel.text = user.name
                self.userEmailLabel.text = user.email
                guard let imageData = Data(base64Encoded: user.image, options: .ignoreUnknownCharacters) else {
                    self.userImageView.image = UIImage.Icons.avatar
                    return
                }
                self.userImageView.image = UIImage(data: imageData) ?? UIImage.Icons.avatar
            }
        }
    }
    
    private func fetchLocalUser() {
        let userUid = State.shared.getUserId()
        CoreDataManager.shared.getUser(uid: userUid) { user in
            guard let user = user else { return }
            DispatchQueue.main.async {
                self.userNameLabel.text = user.name
                self.userEmailLabel.text = user.email
                guard let imageData = Data(base64Encoded: user.image!, options: .ignoreUnknownCharacters) else {
                    self.userImageView.image = UIImage.Icons.avatar
                    return
                }
                self.userImageView.image = UIImage(data: imageData) ?? UIImage.Icons.avatar
            }
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case profileTableView:
            return Setting.profileSettings.count
        case appTableView:
            return Setting.appSettings.count
        case otherTableView:
            return Setting.otherSettings.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.settingsCell.id, for: indexPath) as! SettingsTableViewCell
        
        switch tableView {
        case profileTableView:
            cell.cellLabel.text = Setting.profileSettings[indexPath.row].name
        case appTableView:
            cell.cellLabel.text = Setting.appSettings[indexPath.row].name
        case otherTableView:
            cell.cellLabel.text = Setting.otherSettings[indexPath.row].name
        default:
            return cell
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case profileTableView:
            Setting.profileSettings[indexPath.row].completion(self)
        case appTableView:
            Setting.appSettings[indexPath.row].completion(self)
        case otherTableView:
            Setting.otherSettings[indexPath.row].completion(self)
        default:
            return
            
        }
    }
    
}

