import Foundation

struct AppSettings: Settings {
    var isTracking: Bool
    
    init(isTracking: Bool) {
        self.isTracking = isTracking
    }
    
}
