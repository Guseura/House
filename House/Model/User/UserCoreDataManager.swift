import UIKit
import CoreData

class UserCoreDataManager {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    static let shared = UserCoreDataManager()
    
    private init() {}
    
    func saveUser(id: Int, name: String, email: String, image: String, completion: (_ finished: Bool) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let userDB = UserDB(context: managedContext)
        userDB.id = Int64(id)
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
    
    func getUser(id: Int, completion: (_ complete: Bool, _ user: UserDB?) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let request: NSFetchRequest<UserDB>
        request = UserDB.fetchRequest()
        
        do {
            let users = try managedContext.fetch(request)
            for user in users {
                if user.id == id {
                    completion(true, user)
                    return
                }
            }
            print("CORE DATA: - User was not found")
            completion(false, nil)
        } catch {
            print("CORE DATA: - Unable to fetch data: ", error.localizedDescription)
            completion(false, nil)
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
