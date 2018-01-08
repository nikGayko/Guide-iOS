import Foundation

struct GPSSettings: Settings {
    var isNotifyEnable: Bool
    var notifyRadius: Int
    
    init(isNotifyEnable: Bool, notifyRadius: Int) {
        self.isNotifyEnable = isNotifyEnable
        self.notifyRadius = notifyRadius
    }
}
