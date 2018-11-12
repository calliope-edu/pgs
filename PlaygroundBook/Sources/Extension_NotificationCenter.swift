import Foundation

// https://github.com/ole/NotificationUnregistering
// Wraps the observer token received from NSNotificationCenter.addObserver(forName:object:queue:using:)
// and automatically unregisters from the notification center on deinit.
final class NotificationToken: NSObject {
    let notificationCenter: NotificationCenter
    let token: Any
    
    init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }
    
    deinit {
        LogNotify.log("NotificationToken deinit: unregistering")
        notificationCenter.removeObserver(token)
    }
}

extension NotificationCenter {
    // Convenience wrapper for addObserver(forName:object:queue:using:) that
    //  returns our custom NotificationToken.
    func observe(name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> ()) -> NotificationToken {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) -> Element? {
        if let index = index(of: object) {
            return remove(at: index)
        }
        return nil
    }
}

//MARK: observe all
public class NotificationCenterCatchAll {
    private static var catchAllTocken:NotificationToken?
    
    public static func start(_ block: @escaping (Notification) -> ()) {
        catchAllTocken = NotificationCenter.default.observe(name:nil, object:nil, queue:nil) { (note) in
            block(note)
        }
    }
    
    public static func stop() {
        catchAllTocken = nil
    }
}
