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
    func observe(name: NSNotification.Name?, object obj: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (Notification) -> ()) -> NotificationToken {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }
}

//MARK: observe all
class NotificationCenterCatchAll {
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
