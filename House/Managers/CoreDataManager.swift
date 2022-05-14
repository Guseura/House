import UIKit
import CoreData

class CoreDataManager {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    func saveUser(uid: String, name: String, email: String, image: String, completion: (_ finished: Bool) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let userDB = UserDB(context: managedContext)
        userDB.uid = uid
        userDB.name = name
        userDB.email = email
        userDB.image = image
        
        do {
            try managedContext.save()
            print("CORE DATA: - User saved to the database!")
            completion(true)
        } catch {
            print("CORE DATA: - Failed to save data: ", error.localizedDescription)
            completion(false)
        }
    }
    
    func getUser(uid: String, completion: (_ user: UserDB?) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let request: NSFetchRequest<UserDB>
        request = UserDB.fetchRequest()
        
        do {
            let users = try managedContext.fetch(request)
            for user in users {
                if user.uid == uid {
                    completion(user)
                    return
                }
            }
            print("CORE DATA: - User was not found")
            completion(nil)
        } catch {
            print("CORE DATA: - Unable to fetch data: ", error.localizedDescription)
            completion(nil)
        }
        
    }
    
    
    func deleteUser(user: UserDB) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(user)
        do {
            try managedContext.save()
            print("CORE DATA: - User deleted")
        } catch {
            print("CORE DATA: - Failed to delete data: ", error.localizedDescription)
        }
    }

    func getUsers(completion: (_ complete: Bool, _ users: [UserDB]?) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let request: NSFetchRequest<UserDB>
        request = UserDB.fetchRequest()
        
        do {
            let users = try managedContext.fetch(request)
            print("CORE DATA: - Users fetched, no issue")
            completion(true, users)
        } catch {
            print("CORE DATA: - Unable to fetch data: ", error.localizedDescription)
            completion(false, nil)
        }
    }
}
