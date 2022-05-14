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
            "image": user.image
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

            completion(User(uid: uid, name: name, email: email, image: image))
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
        
        database.child("users").child(uid).updateChildValues(["image": strBase64image]) { (error, ref) in
            error != nil ? completion(false) : completion(true)
        }
    }
    
}

