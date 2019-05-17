import Foundation
import UIKit
import PlaygroundSupport

public class ViewController_Base: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    private var observerTockens:[NotificationToken] = []
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //randomColor()
        addObservers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        observerTockens = []
        NotificationCenterCatchAll.stop()
    }
    
    func addObservers() {
        let nc = NotificationCenter.default
        
        let observer_logNotify = nc.observe(name:LogNotify.logNotifyName, object: nil, queue: .main, using: notificationLogNotify)
        observerTockens.append(observer_logNotify)
        
		let observer_enterBackground = nc.observe(name:UIApplication.didEnterBackgroundNotification, object: nil, queue: .main, using: appDidEnterBackground)
        observerTockens.append(observer_enterBackground)
        
		let observer_willForeground = nc.observe(name:UIApplication.willEnterForegroundNotification, object: nil, queue: .main, using: appWillEnterForeground)
        observerTockens.append(observer_willForeground)
        
        if Debug.catchAll {
            NotificationCenterCatchAll.start { (note) in
                print("")
                NSLog("LogNotify :: \(note)")
                print("")
            }
        }
    }
    
    func notificationLogNotify(note:Notification) -> Void {
        guard let userInfo = note.userInfo,
        let message  = userInfo["message"] as? String,
        let date     = userInfo["date"]    as? String,
        let debugView = self.view.viewWithTag(666) as? UITextView
        else {
            // print("No userInfo found in notification")
            return
         }
         
        let msg = "\(debugView.text!) \(date) --- \(message) \r\n"
        debugView.text = msg
        
        let range = NSMakeRange(msg.count - 1, 1)
        debugView.scrollRangeToVisible(range)
     }
    
    func appDidEnterBackground(note:Notification) {
        LogNotify.log("applicationDidEnterBackground: \(note)")
    }

    func appWillEnterForeground(note:Notification) {
        LogNotify.log("applicationWillEnterForeground: \(note)")
    }
}
