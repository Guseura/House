import UIKit
import FirebaseDatabase

final class FirebaseDatabaseManager {
    
    static let shared = FirebaseDatabaseManager()
    
    private let database = Database.database(url: "https://house-59e2e-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
}

// MARK: - Account Management

extension FirebaseDatabaseManager {
    
    public func insertUser(with user: User) {
        
        guard let imageData = user.image.pngData() else { return }
        let strBase64image = imageData.base64EncodedString(options: .lineLength64Characters)
        
        database.child("users").child(user.uid).setValue([
            "email": user.email,
            "name": user.name,
            "image": strBase64image,
            "memberOf": ""
        ])
    }
    
    public func getUser(with uid: String, completion: @escaping ((User?) -> Void)) {
        
        database.child("users").child(uid).observeSingleEvent(of: .value) { dataSnapshot in

            guard let data = dataSnapshot.value as? NSDictionary else {
                completion(nil)
                return
            }
            
            let name = data["name"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let imageStr = data["image"] as? String ?? ""
            let memberOf = data["memberOf"] as? String ?? ""
            
            var image: UIImage = UIImage()
            
            guard let imageData = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters) else {
                image = UIImage.Icons.avatar
                completion(User(uid: uid, name: name, email: email, image: image, memberOf: memberOf))
                return
            }
            image = UIImage(data: imageData) ?? UIImage.Icons.avatar
            completion(User(uid: uid, name: name, email: email, image: image, memberOf: memberOf))
        }
    }
    
    public func updateUser(name: String, completion: @escaping (Bool)->()) {
        let uid = State.shared.getUserId()
        database.child("users").child(uid).updateChildValues(["name": name]) { (error, ref) in
            error != nil ? completion(false) : completion(true)
        }
    }
    
    public func updateUser(image: UIImage, completion: @escaping (Bool)->()) {
        
        guard let imageData = image.pngData() else {
            completion(false)
            return
        }
        
        let strBase64image = imageData.base64EncodedString(options: .lineLength64Characters)
        let uid = State.shared.getUserId()
        
        database.child("users").child(uid).updateChildValues(["image": strBase64image]) { (error, _) in
            error != nil ? completion(false) : completion(true)
        }
    }
    
    public func updateUser(groupName: String, completion: @escaping (Bool)->()) {
        let uid = State.shared.getUserId()
        database.child("users").child(uid).updateChildValues(["memberOf": groupName]) { (error, _) in
            error == nil ? completion(true) : completion(false)
        }
    }
    
    
}

extension FirebaseDatabaseManager {
    
    public func insertOSBB(creatorId: String, city: String, street: String, completion: @escaping (Bool)->()) {
        
        let groupName = (city + "-" + street).replacingOccurrences(of: " ", with: "-")
        
        database.child("groups").child(groupName).setValue([
            "city": city,
            "street": street,
            "creatorId": creatorId,
            "last_message": "",
            "users": [
                creatorId: true
            ]
        ]) { error, _ in
            self.updateUser(groupName: groupName) { isCompleted in
                isCompleted ? completion(true) : completion(false)
            }
        }
    }
    
    
    public func getAllOSBB(completion: @escaping (([Group]?) -> Void)) {
        
        database.child("groups").observeSingleEvent(of: .value) { dataSnapshot in

            guard let data = dataSnapshot.value as? NSDictionary else {
                completion(nil)
                return
            }
            
            var groups: [Group] = []
            for group in data.allValues {
                
                guard let groupData = group as? NSDictionary else {
                    return
                }
                
                let city = groupData["city"] as? String ?? ""
                let street = groupData["street"] as? String ?? ""
                let creatorId = groupData["creatorId"] as? String ?? ""
                let lastMessage = groupData["last_message"] as? String ?? ""
                
                let users = groupData["users"] as? NSDictionary
                let userUids = users?.allKeys as? [String] ?? []
                
                
                groups.append(Group(city: city, street: street, creatorId: creatorId, lastMessage: lastMessage, users: userUids))
                
            }
            completion(groups)
            return
        }
    }
    
    public func getOSBB(name: String, completion: @escaping ((Group?) -> Void)) {
        
        database.child("groups").child(name).observeSingleEvent(of: .value) { dataSnapshot in
            guard let data = dataSnapshot.value as? NSDictionary else {
                completion(nil)
                return
            }
            
            let city = data["city"] as? String ?? ""
            let street = data["street"] as? String ?? ""
            let creatorId = data["creatorId"] as? String ?? ""
            let lastMessage = data["last_message"] as? String ?? ""
            
            let users = data["users"] as? NSDictionary
            var userUids = users?.allKeys as? [String] ?? []
            
            guard let index = userUids.firstIndex(of: State.shared.getUserId()) else {
                completion(Group(city: city, street: street, creatorId: creatorId, lastMessage: lastMessage, users: userUids))
                return
            }
            userUids.remove(at: index)
            completion(Group(city: city, street: street, creatorId: creatorId, lastMessage: lastMessage, users: userUids))
            return
        }
        
    }
    
    public func addMember(OSBBName: String, uid: String, completion: @escaping ((Bool) -> Void)) {
        
        database.child("groups").child(OSBBName).child("users").child(uid).setValue(true) { error, _ in
            if error != nil {
                completion(false)
                return
            }

            self.updateUser(groupName: OSBBName) { isCompleted in
                completion(isCompleted)
            }
        }
    }
    
    
}

extension FirebaseDatabaseManager {
    
    public func sendMessage(groupName: String, userFromId: String, message: String, completion: @escaping (Bool) -> Void) {
        
        let dataMessage: [String: Any] = [
            "message": message,
            "date": getCurrentDate(),
            "sender_uid": userFromId,
            "is_read": false
        ]
        
        let ref = database.child("groups").child(groupName)
        ref.child("last_message").setValue(message)
        ref.observeSingleEvent(of: .value) { dataSnapshot in
            guard let data = dataSnapshot.value as? NSDictionary else {
                let value: [Any] = [dataMessage]
                self.database.child("groups").child(groupName).child("messages").setValue(value) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                return
            }
            
            var messages = data["messages"] as? [[String: Any]] ?? []
            messages.append(dataMessage)
            
            self.database.child("groups").child(groupName).updateChildValues(["messages": messages]) { error, _ in
                if error == nil {
                    completion(true)
                    return
                }
                completion(false)
                return
            }
        }
    }
    
    public func sendMessage(uid: String, message: String, completion: @escaping (Bool) -> Void) {
        
        let userFromId = State.shared.getUserId()
        let ids = compareStrings(first: uid, second: userFromId)
        
        let conversationId = "conversation_\(ids[0])_\(ids[1])"
        let dataMessage: [String: Any] = [
            "message": message,
            "date": getCurrentDate(),
            "sender_uid": userFromId,
            "is_read": false
        ]
        
        let ref = database.child(conversationId)
        ref.observeSingleEvent(of: .value) { dataSnapshot in
            guard let data = dataSnapshot.value as? NSDictionary else {
                let value: [String: Any] = [
                    "last_message": message,
                    "messages": [dataMessage]
                ]
                self.database.child(conversationId).setValue(value) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                return
            }
            
            var messages = data["messages"] as? [[String: Any]] ?? []
            messages.append(dataMessage)
            
            ref.updateChildValues([
                    "last_message": message,
                    "messages": messages
                ] ) { error, _ in
                completion(error == nil)
                return
            }
        }
    }
    
    public func getLastMessage(uid: String, completion: @escaping (String) -> Void) {
    
        let userFromId = State.shared.getUserId()
        let ids = compareStrings(first: uid, second: userFromId)
        
        let conversationId = "conversation_\(ids[0])_\(ids[1])"
        
        database.child(conversationId).observe(.value) { dataSnapshot in
            
            guard let data = dataSnapshot.value as? NSDictionary else {
                completion("No messages yet")
                return
            }
            
            let message = data["last_message"] as? String ?? ""
            
            if message == "" {
                completion("No messages yet")
                return
            }
            
            completion(message)
        }
    }
    
    public func getMessages(uid: String, completion: @escaping ([Message]?) -> Void) {
        
        let userFromId = State.shared.getUserId()
        let ids = compareStrings(first: uid, second: userFromId)
        
        let conversationId = "conversation_\(ids[0])_\(ids[1])"
        
        database.child(conversationId).observe(.value) { dataSnapshot in
            
            guard let data = dataSnapshot.value as? NSDictionary else {
                completion(nil)
                return
            }
            
            var allMessages: [Message] = []
            
            guard let messagesData = data["messages"] else { return }
            guard let messages = messagesData as? [NSDictionary] else { return }
                        
            for message in messages {
                
                let textMessage = message["message"] as? String ?? ""
                let senderId = message["sender_uid"] as? String ?? ""
                let date = message["date"] as? String ?? ""
                let isRead = message["is_read"] as? Bool ?? false
                
                allMessages.append(Message(message: textMessage, senderId: senderId, date: date, isRead: isRead))
            }
            
            completion(allMessages)
            
        }
    }
    
    public func getMessages(groupName: String, completion: @escaping ([Message]?) -> Void) {
        
        database.child("groups").child(groupName).observe(.value) { dataSnapshot in
            
            guard let data = dataSnapshot.value as? NSDictionary else {
                completion(nil)
                return
            }
            
            var allMessages: [Message] = []
            
            guard let messagesData = data["messages"] else { return }
            guard let messages = messagesData as? [NSDictionary] else { return }
            
            for message in messages {
                
                let textMessage = message["message"] as? String ?? ""
                let senderId = message["sender_uid"] as? String ?? ""
                let date = message["date"] as? String ?? ""
                let isRead = message["is_read"] as? Bool ?? false
                
                allMessages.append(Message(message: textMessage, senderId: senderId, date: date, isRead: isRead))
            }
            completion(allMessages)
            
        }
    }
    
    private func getCurrentDate() -> String {
        let date = Date()
        return date.getFormattedDate(format: "dd.MM.yyyy HH:mm")
    }
    
    private func compareStrings(first: String, second: String) -> [String] {
        return first > second ? [second, first] : [first, second]
    }
    
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
