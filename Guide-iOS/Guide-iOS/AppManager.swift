import Foundation
import SwiftyBeaver

fileprivate enum ApplicationState: Int {
    case tracking = 1
    case pause = 0
}

protocol AppManagerDelegate: class {
    func nearbySightDidChange(newValue value: [Sight])
}

final class AppManager: GPSEventListener {
    
    public static let shared = AppManager()
    
    public var appSettings: AppSettings
    public var gpsSettings: GPSSettings
    private var appSettingsObserver: KeyValueObserver
    fileprivate var applicationState: ApplicationState {
        didSet {
            switch(applicationState) {
            case .pause:
                GPSManager.sharedInstance().stopMonitoringChanges()
                
            case .tracking:
                GPSManager.sharedInstance().startMonitoringChanges()
            }
        }
    }
    
    private init() {
        nearbySightArray = [Sight]()
        
        appSettings = Cache.shared.get(forKey: AppSettings.keyForCache) ?? AppSettings.defaultValue
        gpsSettings = Cache.shared.get(forKey: GPSSettings.keyForCache) ?? GPSSettings.defaultValue
        applicationState = .pause
        appSettingsObserver = KeyValueObserver(observe: appSettings, options: [.new, .initial])
    }
    
    deinit {
        removeObservers()
    }
    
    
    func start() {
        setupObservers()
        
        GPSManager.sharedInstance().subscribeForEvents(self)
        AppColorTheme.shared.setColorThemeThroughApp(.purple)
    }
    
    private weak var managerDelegate: AppManagerDelegate?
    private var lastUpdateTime = Date(timeIntervalSince1970: 0)
    
    public var nearbySightArray: [Sight] {
        didSet {
            managerDelegate?.nearbySightDidChange(newValue: nearbySightArray)
        }
    }
    
    private func updateNearbySightArray(for location: Location) {
        WikipediaAPI.getNearbySights(location: location, radius: 10000, responseCount: 50, callback: {[unowned self] sightArray, result in
            guard let sightArray = sightArray, result else {
                SwiftyBeaver.error("Get nil values")
                return
            }
            self.nearbySightArray = sightArray
        })
        
        lastUpdateTime = Date()
    }
    
    private func setupObservers() {
        appSettingsObserver.observe(forKey: "isTracking", callback: observeValue(_:_:))
    }
    
    private func removeObservers() {
        appSettingsObserver.removeObserver(forKey: "isTracking")
    }
    
    private func observeValue(_ change: [NSKeyValueChangeKey : Any], _ keyPath: String) {
        SwiftyBeaver.info(keyPath + ": " + String(describing: change))
        if keyPath == "isTracking" {
            if let result = change[.newKey] as? Int, let state = ApplicationState.init(rawValue: result) {
                applicationState = state
            }
            
        }
    }
    
    private func notifyAboutSight(_ sight: Sight) {
        Notification.shared.sendNotification(after: 5,
                                             id: String(describing: sight.pageID),
                                             withTitle: "Interesting place close",
                                             body: sight.title ?? "")
    }
    
    public func saveDataInPersistentStorage() {
        Cache.shared.save(object: appSettings, forKey: AppSettings.keyForCache)
        Cache.shared.save(object: gpsSettings, forKey: GPSSettings.keyForCache)
    }
    
    public func setDelegate(_ delegate: AppManagerDelegate) {
        self.managerDelegate = delegate
    }
    
    //MARK: Event listener
    func locationDidChange(_ location: Location) {        
        if Date().timeIntervalSince(lastUpdateTime) > 60 {
            updateNearbySightArray(for: location)
        }
    }
}
