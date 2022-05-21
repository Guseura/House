import UIKit

class MainViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noChatsLabel: UILabel!
    @IBOutlet weak var noChatsDescriptionLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var searchButton: MainButton!
    @IBOutlet weak var addButton: UIButton!
    
    // Table views
    @IBOutlet weak var tableView: UITableView!
    
    // Image Views
    @IBOutlet weak var noChatsImage: UIImageView!
    
    
    // MARK: - Variables
    
    var user: User?
    var posts: [Post]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(tableView, with: Cell.post)
        hideAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    
    // MARK: - Custom functions
    
    private func fetchData() {
        let uid = State.shared.getUserId()
        FirebaseDatabaseManager.shared.getUser(with: uid) { user in
            guard let user = user else { return }
            self.user = user
            let isMemberEmpty = user.memberOf == ""
            self.configure(isMemberEmpty: isMemberEmpty)
            if !isMemberEmpty {
                FirebaseDatabaseManager.shared.getPosts(groupName: user.memberOf) { posts in
                    guard let posts = posts else { return }
                    self.posts = posts
                }
            }
        }
    }
    
    private func configure(isMemberEmpty: Bool) {
        DispatchQueue.main.async {
            self.tableView.isHidden = isMemberEmpty
            self.addButton.isHidden = isMemberEmpty
            self.noChatsImage.isHidden = !isMemberEmpty
            self.noChatsLabel.isHidden = !isMemberEmpty
            self.noChatsDescriptionLabel.isHidden = !isMemberEmpty
            self.searchButton.isHidden = !isMemberEmpty
        }
    }
    
    private func hideAll() {
        noChatsLabel.isHidden = true
        noChatsDescriptionLabel.isHidden = true
        searchButton.isHidden = true
        noChatsImage.isHidden = true
        tableView.isHidden = true
        addButton.isHidden = true
    }
    
    
    // MARK: - @IBActions
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let searchViewController = SearchViewController.load(from: Main.search)
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let user = user else { return }
        let newPostViewController = NewPostViewController.load(from: Main.newPost)
        newPostViewController.user = user
        self.navigationController?.pushViewController(newPostViewController, animated: true)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let posts = posts else { return 0 }
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.post.id, for: indexPath) as! PostTableViewCell
        
        guard let user = user else { return cell }
        guard let post = posts?[indexPath.row] else { return cell }
        
        cell.postTitleLabel.text = post.description
        cell.postTimeLabel.text = String(post.date.split(separator: " ")[1])
        cell.postLikesLabel.text = String(post.likedBy.count)
        
        if post.image == "" {
            cell.postImageViewHeightConstraint.constant = 0
            cell.postTitleLabelTopConstraint.constant = 20
        } else {
            cell.postImageViewHeightConstraint.constant = 200
            cell.postTitleLabelTopConstraint.constant = 12
        }
        
        let isLiked = post.likedBy.firstIndex(of: user.uid) ?? -1
        let currentImage = isLiked == -1 ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        cell.likeButton.setImage(currentImage, for: .normal)
        
        cell.onLikeButtonPressed = {
            FirebaseDatabaseManager.shared.likePost(groupName: user.memberOf, index: String(indexPath.row)) { isCompleted in
                if isCompleted {
                    print("Cool")
                }
            }
        }
        
        guard let url = URL(string: post.image) else { return cell }
        cell.postImageView.load(url: url) { image in }
        
        return cell
    }
    
}
