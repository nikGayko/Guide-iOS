import Foundation
import SwiftyBeaver

final class AppManager: GPSEventListener {
    
    public static let shared = AppManager()
    
    private init() {
        nearbySightArray = [Sight]()
        GPSManager.sharedInstance().subscribeForEvents(self)
        isWorking = true
    }
    
    private var managerDelegate: AppManagerDelegate?
    private var lastUpdateTime = Date(timeIntervalSince1970: 0)
    
    public var isWorking: Bool! {
        didSet {
            if (!isWorking) {
                stopTracking()
            } else {
                launchTracking()
            }
        }
    }
    
    public var nearbySightArray: [Sight] {
        didSet {
            managerDelegate?.nearbySightDidChange(newValue: nearbySightArray)
        }
    }
    
    private func updateNearbySightArray(for location: Location) {
        WikipediaAPI.getNearbySights(location: location, radius: 10000, responseCount: 20, callback: {[unowned self] sightArray, result in
            guard let sightArray = sightArray, result else {
                SwiftyBeaver.error("Get nil values")
                return
            }
            self.nearbySightArray = sightArray
            
            if sightArray[0].distance! < 200 {
                self.notifyAboutSight(sightArray[0])
            }
        })
        
        lastUpdateTime = Date()
    }
    
    private func notifyAboutSight(_ sight: Sight) {
        Notification.shared.sendNotification(after: 5,
                                             id: String(describing: sight.pageID),
                                             withTitle: "Interesting place close",
                                             body: sight.title ?? "")
    }
    
    func launchTracking() {
        GPSManager.sharedInstance().startMonitoringChanges()
    }
    
    func stopTracking() {
        GPSManager.sharedInstance().stopMonitoringChanges()
    }
    
    public func setDelegate(_ delegate: AppManagerDelegate) {
        self.managerDelegate = delegate
    }
    
    //MARK: Event listener
    func locationDidChange(_ location: Location) {
        SwiftyBeaver.debug(location)
        
        if Date().timeIntervalSince(lastUpdateTime) > 60 {
            updateNearbySightArray(for: location)
        }
    }
    
}
