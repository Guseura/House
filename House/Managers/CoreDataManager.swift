import UIKit
import CoreData

class CoreDataManager {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    func saveUser(uid: String, name: String, email: String, image: String, memberOf: String, completion: (_ finished: Bool) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let userDB = UserDB(context: managedContext)
        userDB.uid = uid
        userDB.name = name
        userDB.email = email
        userDB.image = image
        userDB.memberOf = memberOf
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func updateUser(uid: String, memberOf: String) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let request: NSFetchRequest<UserDB>
        request = UserDB.fetchRequest()
        
        do {
            let users = try managedContext.fetch(request)
            for user in users {
                if user.uid == uid {
                    user.memberOf = memberOf
                    do {
                        try managedContext.save()
                        return
                    } catch { }
                }
            }
        } catch { }
        
    }
    
    func updateUser(uid: String, name: String, image: String) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let request: NSFetchRequest<UserDB>
        request = UserDB.fetchRequest()
        
        do {
            let users = try managedContext.fetch(request)
            for user in users {
                if user.uid == uid {
                    user.name = name
                    user.image = image
                    do {
                        try managedContext.save()
                        return
                    } catch { }
                }
            }
        } catch { }
        
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
            completion(nil)
        } catch {
            completion(nil)
        }
        
    }
    
    
    func deleteUser(user: UserDB) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(user)
        do {
            try managedContext.save()
        } catch { }
    }

    func getUsers(completion: (_ complete: Bool, _ users: [UserDB]?) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let request: NSFetchRequest<UserDB>
        request = UserDB.fetchRequest()
        
        do {
            let users = try managedContext.fetch(request)
            completion(true, users)
        } catch {
            completion(false, nil)
        }
    }
}
