import UIKit

extension UIViewController {
    
    public static func load(from screen: StoryboardScreen) -> Self {
        return screen.storyboard.instantiateViewController(withIdentifier: screen.id) as! Self
    }
    
    public func showPopup(_ popup: UIViewController) {
        self.addChild(popup)
        popup.view.frame = self.view.frame
        self.view.addSubview(popup.view)
        popup.didMove(toParent: self)
    }
    
    public func showNetworkConnectionAlert(completion: (() -> ())? = nil) {
        let alertOk = UIAlertAction(title: localized("alert.action.ok"), style: .default) { _ in
            completion?() ?? ()
        }
        self.present(getAlert(title: localized("alert.connection.title"),
                              message: localized("alert.connection.message"),
                              actions: alertOk),
                     animated: true,
                     completion: nil
        )
    }
    
    public func showAlreadySubscribedAlert(completion: (() -> ())? = nil) {
        let alertOk = UIAlertAction(title: localized("alert.action.ok"), style: .default) { _ in
            completion?() ?? ()
        }
        self.present(getAlert(title: localized("alert.subscribed.title"),
                              message: localized("alert.subscribed.message"),
                              actions: alertOk),
                     animated: true,
                     completion: nil
        )
    }
    
    public func showNotSubscriberAlert(completion: (() -> ())? = nil) {
        let alertOk = UIAlertAction(title: localized("alert.action.ok"), style: .default) { _ in
            completion?() ?? ()
        }
        self.present(getAlert(title: localized("alert.notSubscriber.title"),
                              message: localized("alert.notSubscriber.message"),
                              actions: alertOk),
                     animated: true,
                     completion: nil
        )
    }
    
    public func showRestoredAlert(completion: (() -> ())? = nil) {
        let alertOk = UIAlertAction(title: localized("alert.action.ok"), style: .default) { _ in
            completion?() ?? ()
        }
        self.present(getAlert(title: localized("alert.restored.title"),
                              message: localized("alert.restored.message"),
                              actions: alertOk),
                     animated: true,
                     completion: nil
        )
    }
    
}
