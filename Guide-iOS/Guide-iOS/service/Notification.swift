import Foundation
import UserNotifications
import NotificationCenter

final class Notification {
    
    static let shared = Notification()
    
    private init() { }
    
    func registerForNotifications(types: UIUserNotificationType, with completion: @escaping ((Bool, Error?) -> Void)) {
        if #available(iOS 10.0, *) {
            let options = types.authorizationOptions()
            UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: completion)
        } else {
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    func sendNotification(after delay: TimeInterval, id: String, withTitle title: String, body: String, subTitle: String? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        if let subTitle = subTitle {
            content.subtitle = subTitle
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
