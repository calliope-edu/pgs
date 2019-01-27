import Foundation

//FIXME: add debug

public class LogNotify {
    
    static let logNotifyName = Notification.Name("cc.calliope.mini.logger")
    
    public class func log(_ msg: String) {
        
        let main = Thread.current.isMainThread
        let thread = main ? "[main]" : "[back]"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ssss"
        let now = formatter.string(from: Date())
        
        NSLog("LogNotify:: \(thread) : \(msg)")
		//this seems to have been synchronous, so no matter which queue it was invoked from, if the main queue was waiting the queue had to wait, too. This lead to deadlocks
		DispatchQueue.main.async {
			NotificationCenter.default.post(name:logNotifyName, object: nil, userInfo:["message":msg, "date":now])
		}
    }
    
}
