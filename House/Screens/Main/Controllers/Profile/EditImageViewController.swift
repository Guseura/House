import UIKit

class EditImageViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var editLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var saveButton: MainButton!
    
    // Image Views
    @IBOutlet weak var userImage: UIImageView!
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // Constraints
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configure(tableView, with: Cell.settingsCell)
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentHeight
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        tableView.roundCorners(radius: 10)
        userImage.capsuleCorners()
    }
    
    private func fetchData() {
        CoreDataManager.shared.getUser(uid: State.shared.getUserId()) { user in
            guard let user = user else { return }
            guard let imageData = Data(base64Encoded: user.image!, options: .ignoreUnknownCharacters) else { return }
            self.userImage.image = UIImage(data: imageData) ?? UIImage.Icons.avatar
        }
    }
    
    // MARK: - @IBActions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        guard let image = userImage.image else {
            return
        }
        
        FirebaseDatabaseManager.shared.updateUser(image: image) { isSuccess in
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
            } else {
                
            }
        }
        
//        UserNetwork.shared.updateUser(image: image, id: State.shared.getUserEmail()) { result in
//            switch result {
//            case .success(_):
//                self.navigationController?.popViewController(animated: true)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    
}

extension EditImageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.settingsCell.id, for: indexPath) as! SettingsTableViewCell
        cell.cellLabel.text = indexPath.row == 0 ? "New image" : "Delete image"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            ImagePickerManager.shared.pickImage(self) { image in
                DispatchQueue.main.async {
                    self.userImage.image = image
                }
            }
        } else {
            DispatchQueue.main.async {
                self.userImage.image = UIImage.Icons.avatar
            }
        }
    }
    
}
