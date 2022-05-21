import UIKit
import FirebaseAuth

struct Setting {
    
    var name: String = ""
    var completion: (_ controller: UIViewController) -> ()
    
    static func getProfileSettings() -> [Setting] {
        return [
            Setting(name: localized("settings.edit.name"), completion: { controller in
                let editNameViewController = EditNameViewController.load(from: Main.editName)
                controller.navigationController?.pushViewController(editNameViewController, animated: true)
            }),
            Setting(name: localized("settings.edit.image"), completion: { controller in
                let editImageViewController = EditImageViewController.load(from: Main.editImage)
                controller.navigationController?.pushViewController(editImageViewController, animated: true)
            })
        ]
    }
    
    static func getAppSettings() -> [Setting] {
        return [
            Setting(name: localized("settings.language"), completion: { controller in
                let languageViewController = LanguageViewController.load(from: Main.language)
                controller.navigationController?.pushViewController(languageViewController, animated: true)
            })
        ]
    }
    
    static func getOtherSettings() -> [Setting] {
        return [
            Setting(name: localized("settings.logout"), completion: { controller in
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    State.shared.setIsLoggedIn(to: false)
                    State.shared.setUserId(to: "")
                    controller.dismiss(animated: true, completion: nil)
                } catch { }
            })
        ]
    }
    
}
