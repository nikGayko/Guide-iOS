import UIKit
import SwiftyBeaver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        askNotificationPermission()
        setupLoger()
        AppManager.shared.start()
        return true
    }
    
    private func setupLoger() {
        SwiftyBeaver.addDestination(ConsoleDestination())
    }
    
    private func askNotificationPermission() {
        Notification.shared.registerForNotifications(types: [.alert, .sound], with: {result, error in
            if result {
                SwiftyBeaver.info("Permission accepted")
            } else {
                SwiftyBeaver.info("Permission denied")
            }
        })
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //Cache all changes during session
        AppManager.shared.saveDataInPersistentStorage()
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}

