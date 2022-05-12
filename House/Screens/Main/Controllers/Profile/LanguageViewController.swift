import UIKit

class LanguageViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var languageLabel: UILabel!

    // Table Views
    @IBOutlet weak var tableView: UITableView!
    
    // Constraints
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(tableView, with: Cell.languageCell)
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentHeight
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        tableView.roundCorners(radius: 10)
    }
    
    // MARK: - @IBActions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.languageCell.id, for: indexPath) as! LanguageTableViewCell
        let language = Language.languages[indexPath.row]
        cell.languageLabel.text = language.name
        cell.checkImage.image = language.code == State.shared.getLanguageCode() ? UIImage.Icons.checked : UIImage.Icons.unchecked
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        State.shared.setLanguage(to: Language.languages[indexPath.row].code)
        tableView.reloadData()
    }
    
}
