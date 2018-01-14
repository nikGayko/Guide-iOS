import Foundation
import SwiftyBeaver

class KeyValueObserver: NSObject {
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

