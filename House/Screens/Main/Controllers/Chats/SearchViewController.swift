import UIKit

class SearchViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var searchLabel: UILabel!
    
    // Table Views
    @IBOutlet weak var tableView: UITableView!
    
    // Search Bars
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Variables
    
    var allGroups: [Group] = []
    var toShow: [Group] = []
    
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(tableView, with: Cell.searchCell)
        searchBar.delegate = self
        fetchData()
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        tableView.roundCorners(radius: 10)
    }
    
    private func fetchData() {
        FirebaseDatabaseManager.shared.getAllOSBB { groups in
            guard let groups = groups else {
                return
            }
            self.allGroups = groups
            self.toShow = groups
            self.tableView.reloadData()
        }
    }
    
    private func showGroupsPopup() {
        let groupPopup = GroupPopup.load(from: Popup.groupPopup)
        groupPopup.completion = { toCreate in
            if toCreate {
                let createGroupViewController = CreateGroupViewController.load(from: Main.create)
                self.navigationController?.pushViewController(createGroupViewController, animated: true)
            }
        }
        self.showPopup(groupPopup)
    }
    
    // MARK: - @IBActions
    
    @IBAction func createButtonPressed(_ sender: Any) {
        let createGroupViewController = CreateGroupViewController.load(from: Main.create)
        self.navigationController?.pushViewController(createGroupViewController, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Extension : UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.searchCell.id, for: indexPath) as! SearchTableViewCell
        
        let group = toShow[indexPath.row]
        cell.streetLabel.text = group.street
        cell.cityStreetLabel.text = group.city + ", " + group.street
        cell.usersLabel.text = String(group.users.count)
        
        if indexPath.row == toShow.count - 1 {
            cell.cornerBottomCorners()
        }
        
        if indexPath.row == 0 {
            cell.cornerTopCorners()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let osbbName = (toShow[indexPath.row].city + "-" + toShow[indexPath.row].street).replacingOccurrences(of: " ", with: "-")
        let uid = State.shared.getUserId()
        FirebaseDatabaseManager.shared.addMember(OSBBName: osbbName, uid: uid) { isCompleted in
            if isCompleted {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
}

// MARK: - Extension : UISearchBar

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
        self.toShow = []
        
        guard let searchText = searchBar.text, searchText.replacingOccurrences(of: " ", with: "").count != 0 else {
            toShow = allGroups
            tableView.reloadData()
            return
        }
        
        for group in allGroups {
            if group.street.range(of: searchText, options: .caseInsensitive) != nil {
                toShow.append(group)
            }
        }
        
        if toShow.count == 0 {
            tableView.reloadData()
            showGroupsPopup()
            return
        }
        
        tableView.reloadData()
        
    }
    
}
