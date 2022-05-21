import UIKit

class CityViewController: BaseViewController {
    
    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var searchLabel: UILabel!
    
    // Table Views
    @IBOutlet weak var tableView: UITableView!
    
    // Search bars
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    
    public var completion: (_ city: String) -> () = { _ in }
    private var selectedIndex: Int = -1
    private var toShow: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configure(tableView, with: Cell.languageCell)
        searchBar.delegate = self
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        searchLabel.localize(with: "create.group.city")
        searchBar.placeholder = localized("chats.search")
    }
    
    override func configureUI() {
        tableView.roundCorners(radius: 10)
    }
    
    private func fetchData() {
        City.get()
        toShow = City.all
    }
    
    // MARK: - @IBActions

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.languageCell.id, for: indexPath) as! LanguageTableViewCell
        cell.languageLabel.text = toShow[indexPath.row]
        cell.checkImage.image = indexPath.row == selectedIndex ? UIImage.Icons.checked : UIImage.Icons.unchecked
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LanguageTableViewCell
        cell.checkImage.image = UIImage.Icons.checked
        self.completion(toShow[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.toShow = []
        selectedIndex = -1
        for city in City.all {
            if city.range(of: searchText, options: .caseInsensitive) != nil {
                toShow.append(city)
            }
        }
        tableView.reloadData()
    }
    
}
