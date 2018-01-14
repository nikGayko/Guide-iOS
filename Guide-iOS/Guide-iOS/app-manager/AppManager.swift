import Foundation
import SwiftyBeaver

fileprivate enum ApplicationState: Int {
    case tracking = 1
    case pause = 0
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

fileprivate class KeyValueObserver: NSObject {
    typealias KeyValueObservingCallback = (_ change: [NSKeyValueChangeKey : Any], _ forKeyPath: String) -> Void
    
    var object: NSObject
    var options: NSKeyValueObservingOptions
    var observingValues = [String:KeyValueObservingCallback]()
    var context: UnsafeMutableRawPointer? = nil
    
    init(observe object: NSObject, options: NSKeyValueObservingOptions) {
        self.object = object
        self.options = options
    }
    
    convenience init(observe object: NSObject, options: NSKeyValueObservingOptions, keyPath: String, callback: @escaping KeyValueObservingCallback) {
        self.init(observe: object, options: options)
        observe(forKey: keyPath, callback: callback)
    }
    
    func observe(forKey key: String, callback: @escaping KeyValueObservingCallback) {
        observingValues[key] = callback
        object.addObserver(self, forKeyPath: key, options: self.options, context: self.context)
    }
    
    func removeObserver(forKey key: String) {
        observingValues[key] = nil
        object.removeObserver(self, forKeyPath: key)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, let keyPath = keyPath else {
            SwiftyBeaver.warning("Necessary doesn't exist")
            return
        }
        
        if let callback = observingValues[keyPath] {
            callback(change, keyPath)
        } else {
            SwiftyBeaver.warning("Observing useless value \"\(keyPath)\"")
        }
    }
    
    
}
