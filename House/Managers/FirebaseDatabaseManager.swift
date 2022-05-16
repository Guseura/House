import UIKit
import FirebaseDatabase

final class FirebaseDatabaseManager {
    
    static let shared = FirebaseDatabaseManager()
    
    private let database = Database.database(url: "https://house-59e2e-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
}

// MARK: - Account Management

extension FirebaseDatabaseManager {
    
    public func insertUser(with user: User) {
        
        database.child("users").child(user.uid).setValue([
            "email": user.email,
            "name": user.name,
            "image": user.image,
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
            let image = data["image"] as? String ?? ""
            let memberOf = data["memberOf"] as? String ?? ""

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
                
                let users = groupData["users"] as? NSDictionary
                let userUids = users?.allKeys as? [String] ?? []
                
                
                groups.append(Group(city: city, street: street, creatorId: creatorId, users: userUids))
                
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
            
            let users = data["users"] as? NSDictionary
            var userUids = users?.allKeys as? [String] ?? []
            
            guard let index = userUids.firstIndex(of: State.shared.getUserId()) else {
                completion(Group(city: city, street: street, creatorId: creatorId, users: userUids))
                return
            }
            userUids.remove(at: index)
            completion(Group(city: city, street: street, creatorId: creatorId, users: userUids))
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

