import Foundation

class GPSSettings: NSObject, Cachable {
    @objc dynamic var isNotifyEnable: Bool
    @objc dynamic var notifyRadius: Int
    
    init(isNotifyEnable: Bool, notifyRadius: Int) {
        self.isNotifyEnable = isNotifyEnable
        self.notifyRadius = notifyRadius
    }
    
    //MARK: - Cachable protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(isNotifyEnable, forKey: "isNotifyEnable")
        aCoder.encode(notifyRadius, forKey: "notifyRadius")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let isNotifyEnable = aDecoder.decodeBool(forKey: "isNotifyEnable")
        let notifyRadius = aDecoder.decodeInteger(forKey: "notifyRadius")
        
        self.init(isNotifyEnable: isNotifyEnable, notifyRadius: notifyRadius)
    }
    
    static var defaultValue: GPSSettings = {
        return GPSSettings(isNotifyEnable: true, notifyRadius: 200)
    }()
    
    static var keyForCache: String {
        return String(describing: self)
    }
}
