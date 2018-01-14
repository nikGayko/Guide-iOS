import Foundation

class AppSettings: NSObject, Cachable {
    @objc dynamic var isTracking: Bool
    
    init(isTracking: Bool) {
        self.isTracking = isTracking
    }
    
    //MARK: - Cachable protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(isTracking, forKey: "isTracking")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let isTracking = aDecoder.decodeBool(forKey: "isTracking")
        
        self.init(isTracking: isTracking)
    }
    
    static var defaultValue: AppSettings = {
        return AppSettings(isTracking: true)
    }()
    
    static var keyForCache: String {
        return String(describing: self)
    }
}
