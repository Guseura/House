import UIKit

class ChatViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var userNameLabel: UILabel!
    
    // Image views
    @IBOutlet weak var userImageView: UIImageView!
    
    // Table Views
    @IBOutlet weak var tableView: UITableView!
    
    // Text Views
    @IBOutlet weak var messageTextView: UITextView!
    
    // Constraints
    @IBOutlet weak var messageTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    
    enum chatType {
        case group
        case user
    }
    
    public var user: User?
    public var group: Group?
    public var chatImage: UIImage?
    public var type: chatType!
    
    private var messages: [Message]?
    private var isMessageOversized = false
    private var textViewHeight: CGFloat {
        messageTextView.layoutIfNeeded()
        return messageTextView.contentSize.height
    }
    
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenForMessages()
        configure(tableView, with: Cell.incoming, Cell.outgoing, Cell.incomingImage, Cell.outgoingImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotifications()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotifications()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Custom functions
    
    override func configureUI() {
        DispatchQueue.main.async {
            
            self.configureTextView()
            self.userImageView.capsuleCorners()
            
            switch self.type{
            case .user:
                guard let user = self.user else { return }
                self.userNameLabel.text = user.name
                self.userImageView.image = user.image
                break
            case .group:
                guard let group = self.group else { return }
                self.userNameLabel.text = group.street
                self.userImageView.image = UIImage.Icons.groupIcon
                break
            case .none:
                break
            }
            
        }
    }
    
    private func listenForMessages() {
        switch type {
        case .user:
            listenForUserMessages()
            break
        case .group:
            listenForGroupMessages()
            break
        case .none:
            break
        }
    }
    
    private func listenForUserMessages() {
        guard let user = user else { return }
        FirebaseDatabaseManager.shared.getMessages(uid: user.uid) { [weak self] messages in
            guard let messages = messages else { return }
            DispatchQueue.main.async {
                self?.messages = messages
                self?.tableView.reloadData()
                self?.scrollToBottom()
            }
        }
    }
    
    private func listenForGroupMessages() {
        guard let group = group else { return }
        let groupName = (group.city + "-" + group.street).replacingOccurrences(of: " ", with: "-")
        FirebaseDatabaseManager.shared.getMessages(groupName: groupName) { [weak self] messages in
            DispatchQueue.main.async {
                guard let messages = messages else { return }
                self?.messages = messages
                self?.tableView.reloadData()
                self?.scrollToBottom()
            }
        }
    }
    
    private func configureTextView() {
        messageTextView.text = localized("chat.write.message")
        messageTextView.delegate = self
        messageTextView.textColor = UIColor.TextLightGray
        messageTextView.layer.cornerRadius = 4
        messageTextView.layer.masksToBounds = true
        let inset: CGFloat = 6
        messageTextView.textContainerInset = UIEdgeInsets(top: inset, left: 8, bottom: inset, right: 8)
        messageTextViewHeightConstraint.constant = textViewHeight
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            guard let messages = self.messages else { return }
            if messages.count > 0 {
                let indexPath = IndexPath(row: messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - @objc functions
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            DispatchQueue.main.async {
                self.textViewBottomConstraint.constant = keyboardFrame.cgRectValue.height + 12 - safeAreaBottomInset
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                    self.view.layoutIfNeeded()
                }
                self.scrollToBottom()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            self.textViewBottomConstraint.constant = 28
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            }
            
            if self.messageTextView.text == "" {
                self.messageTextView.text = localized("chat.write.message")
                self.messageTextView.textColor = UIColor.TextLightGray
            }
            
            self.scrollToBottom()
        }
    }
    
    private func sendGroupMessage() {
        guard let group = group else { return }
        guard let message = messageTextView.text else { return }
        messageTextView.text = ""
        
        let userId = State.shared.getUserId()
        FirebaseDatabaseManager.shared.getUser(with: userId) { user in
            
            let groupName = (group.city + "-" + group.street).replacingOccurrences(of: " ", with: "-")
            
            FirebaseDatabaseManager.shared.sendMessage(groupName: groupName, userFromId: userId, message: message) { isSent in
                isSent ? print("Message was sent!") : print("Message was not sent!")
            }
            
        }
    }
    
    private func sendGroupMessage(image: UIImage) {
        guard let group = group else { return }
        let userId = State.shared.getUserId()
        
        FirebaseDatabaseManager.shared.getUser(with: userId) { user in
            let groupName = (group.city + "-" + group.street).replacingOccurrences(of: " ", with: "-")
            FirebaseDatabaseManager.shared.sendMessage(groupName: groupName, userFromId: userId, image: image) { isSent in
                isSent ? print("Message was sent!") : print("Message was not sent!")
            }
        }
    }
    
    private func sendUserMessage() {
        guard let user = user else { return }
        guard let message = messageTextView.text else { return }
        messageTextView.text = ""
        
        FirebaseDatabaseManager.shared.sendMessage(uid: user.uid, message: message) { isSent in
            isSent ? print("Message was sent!") : print("Message was not sent!")
        }
    }
    
    private func sendUserMessage(image: UIImage) {
        guard let user = user else { return }
        FirebaseDatabaseManager.shared.sendMessage(uid: user.uid, image: image) { isSent in
            isSent ? print("Message was sent!") : print("Message was not sent!")
        }
    }
    
    
    // MARK: - @IBActions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        switch type {
        case .user:
            sendUserMessage()
            break
        case .group:
            sendGroupMessage()
            break
        case .none:
            break
        }
    }
    
    @IBAction func clipButtonPressed(_ sender: Any) {
        ImagePickerManager.shared.pickImage(self) { [weak self] image in
            guard let strongSelf = self else { return }
            switch strongSelf.type {
            case .user:
                strongSelf.sendUserMessage(image: image)
                break
            case .group:
                strongSelf.sendGroupMessage(image: image)
                break
            case .none:
                break
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - Extension: UITableViewDelegate, UITableViewDataSource

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages![indexPath.row]
        let time = String(message.date.split(separator: " ")[1])
        
        if message.type == "text" {
            
            // Outgoing text table view cell
            if message.senderId == State.shared.getUserId() {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.outgoing.id, for: indexPath) as! OutgoingMessageTableViewCell
                cell.messageTextLabel.text = message.message
                cell.messageTime.text = time
                cell.messageBackgroundTopConstraint.constant = 0
                if indexPath.row == 0 {
                    cell.messageBackgroundTopConstraint.constant = 12
                }
                return cell
                
            // Incoming text table view cell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.incoming.id, for: indexPath) as! IncomingMessageTableViewCell
                
                cell.messageTextLabel.text = message.message
                cell.messageTimeLabel.text = time
                
                cell.messageSenderImage.isHidden = false
                
                if indexPath.row != messages!.count-1 {
                    if message.senderId == messages![indexPath.row+1].senderId {
                        cell.configureWithoutImage()
                    }
                }
                
                cell.usernameHeightConstraint.constant = 12
                cell.usernameBottomConstraint.constant = 2
                cell.messageBackgroundTopConstraint.constant = 0
                cell.messageUsernameLabel.isHidden = false
                
                if indexPath.row != 0 {
                    if message.senderId == messages![indexPath.row-1].senderId {
                        cell.usernameHeightConstraint.constant = 0
                        cell.usernameBottomConstraint.constant = 0
                        cell.messageUsernameLabel.isHidden = true
                        return cell
                    }
                } else {
                    cell.messageBackgroundTopConstraint.constant = 12
                }
                
                switch type {
                case .user:
                    guard let user = user else { return cell }
                    cell.messageUsernameLabel.text = user.name
                    cell.messageSenderImage.image = self.userImageView.image
                case .group:
                    FirebaseDatabaseManager.shared.getUser(with: message.senderId) { user in
                        guard let user = user else { return }
                        cell.messageUsernameLabel.text = user.name
                        cell.messageSenderImage.image = user.image
                    }
                case .none:
                    break
                }

                return cell
                
            }
        } else {
            // Outgoing image cell
            if message.senderId == State.shared.getUserId() {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.outgoingImage.id, for: indexPath) as! OutgoingImageTableViewCell
                
                cell.messageTime.text = time
                cell.messageBackgroundTopConstraint.constant = 0
                if indexPath.row == 0 {
                    cell.messageBackgroundTopConstraint.constant = 12
                }
                
                guard let url = URL(string: message.message) else {
                    return cell
                }
                cell.messageImage.load(url: url) { image in
                    DispatchQueue.main.async {
                        guard let image = image else { return }
                        cell.messageImage.image = image
                        cell.layoutIfNeeded()
                    }
                }
                return cell
            
            // Incoming image cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.incomingImage.id, for: indexPath) as! IncomingImageTableViewCell
                
                cell.messageTimeLabel.text = time
                cell.messageSenderImage.isHidden = false
                
                if indexPath.row != messages!.count-1 {
                    if message.senderId == messages![indexPath.row+1].senderId {
                        cell.configureWithoutImage()
                    }
                }
                
                cell.usernameHeightConstraint.constant = 12
                cell.usernameBottomConstraint.constant = 2
                cell.messageBackgroundTopConstraint.constant = 0
                cell.messageUsernameLabel.isHidden = false
                
                if indexPath.row != 0 {
                    if message.senderId == messages![indexPath.row-1].senderId {
                        cell.usernameHeightConstraint.constant = 0
                        cell.usernameBottomConstraint.constant = 0
                        cell.messageUsernameLabel.isHidden = true
                        return cell
                    }
                } else {
                    cell.messageBackgroundTopConstraint.constant = 12
                }
                
                switch type {
                case .user:
                    guard let user = user else { return cell }
                    cell.messageUsernameLabel.text = user.name
                    cell.messageSenderImage.image = self.userImageView.image
                case .group:
                    FirebaseDatabaseManager.shared.getUser(with: message.senderId) { user in
                        guard let user = user else { return }
                        cell.messageUsernameLabel.text = user.name
                        cell.messageSenderImage.image = user.image
                    }
                case .none:
                    break
                }
                
                guard let url = URL(string: message.message) else {
                    return cell
                }
                cell.messageImage.load(url: url) { image in
                    DispatchQueue.main.async {
                        guard let image = image else { return }
                        cell.messageImage.image = image
                        cell.layoutIfNeeded()
                    }
                }
                return cell
            }
        }
    }
}


// MARK: - Extension: UITextViewDelegate

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight: CGFloat = 100
        isMessageOversized = textViewHeight > maxHeight
        messageTextViewHeightConstraint.constant = isMessageOversized ? maxHeight : textViewHeight
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == localized("chat.write.message") {
            textView.text = ""
            textView.textColor = UIColor.TextMainColor
        }
    }
    
}
