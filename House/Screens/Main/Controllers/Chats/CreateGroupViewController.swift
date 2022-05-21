import UIKit

class CreateGroupViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var createLabel: UILabel!
    
    // Button
    @IBOutlet weak var createButton: UIButton!
    
    // Table Views
    @IBOutlet weak var tableView: UITableView!
    
    // Constraints
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    
    var city = localized("create.group.city") {
        didSet {
            self.tableView.reloadData()
        }
    }
    var street = localized("create.group.street") {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(tableView, with: Cell.settingsCell)
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentHeight
    }
    
    
    // MARK: - Custom functions
    
    override func localize() {
        createLabel.localize(with: "create.group.title")
        createButton.localize(with: "create.group.create")
    }
    
    override func configureUI() {
        tableView.roundCorners(radius: 10)
    }
    
    // MARK: - @IBActions
    
    @IBAction func createButtonPressed(_ sender: Any) {
        if city != localized("create.group.city") && street != localized("create.group.street") {
            let userId = State.shared.getUserId()
            FirebaseDatabaseManager.shared.insertOSBB(creatorId: userId, city: city, street: street) { isCompleted in
                if isCompleted {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CreateGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.settingsCell.id, for: indexPath) as! SettingsTableViewCell
        cell.cellLabel.text = indexPath.row == 0 ? city : street
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cityViewController = CityViewController.load(from: Main.city)
            cityViewController.completion = { city in
                self.city = city
            }
            self.navigationController?.pushViewController(cityViewController, animated: true)
        } else {
            let streetViewController = StreetViewController.load(from: Main.street)
            streetViewController.completion = { street in
                self.street = street
            }
            self.navigationController?.pushViewController(streetViewController, animated: true)
        }
    }
    
}
