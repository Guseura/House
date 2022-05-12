import UIKit

struct Setting {
    
    let name: String
    let completion: (_ controller: UIViewController)->()
    
    // Profile settings
    
    static let profileSettings: [Setting] = [
        
        Setting(name: "Edit name", completion: { controller in
            let editNameViewController = EditNameViewController.load(from: Main.editName)
            controller.navigationController?.pushViewController(editNameViewController, animated: true)
        }),
        
        Setting(name: "Edit image", completion: { controller in
            let editImageViewController = EditImageViewController.load(from: Main.editImage)
            controller.navigationController?.pushViewController(editImageViewController, animated: true)
        })
        
    ]
    
    // App settings
    
    static let appSettings: [Setting] = [
        
        Setting(name: "Language", completion: { controller in
            let languageViewController = LanguageViewController.load(from: Main.language)
            controller.navigationController?.pushViewController(languageViewController, animated: true)
        })
        
    ]
    
    // Other
    
    static let otherSettings: [Setting] = [
        
        Setting(name: "Privacy Policy", completion: { controller in
            
        }),
        
        Setting(name: "Terms of use", completion: { controller in
            
        }),
        
        Setting(name: "Contact us", completion: { controller in
            
        })
        
    ]
    
}
