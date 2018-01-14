import Foundation
import SwiftyBeaver

@objc protocol Cachable: NSObjectProtocol, NSCoding {
    @objc optional static var keyForCache: String { get }
}

class Cache {
    static let shared = Cache()
    private let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    func save(object: Cachable, forKey key: String) {
        guard object is NSObject else {
            SwiftyBeaver.error("Object doesn't conform to type NSObject")
            return
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        userDefaults.set(data, forKey: key)
    }
    
    func get<T: Cachable>(forKey key: String) -> T? {
        var t: T? = nil
        if let data = userDefaults.object(forKey: key) as? Data {
            t = NSKeyedUnarchiver.unarchiveObject(with: data) as? T
        }
        return t
    }
}
