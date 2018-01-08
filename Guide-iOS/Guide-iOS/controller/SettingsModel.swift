import Foundation

//************************************************************
//----------------------ViewModel for cell--------------------
//************************************************************
enum SettingsCellType {
    case binary
    case picker
}

protocol CellItem {
    var type: SettingsCellType { get }
}

class SwitchCellItem: CellItem {
    var type: SettingsCellType {
        return .binary
    }
    
    var isOn: Bool
    var title: String
    
    init(title: String, isOn: Bool) {
        self.isOn = isOn
        self.title = title
    }
}

class PickerCellItem: CellItem {
    var type: SettingsCellType {
        return .picker
    }
    
    var title: String
    var currentValue: String
    var availableValueArray: [String]
    
    init(title: String, currentValue: String, availableValueArray: [String]) {
        self.title = title
        self.currentValue = currentValue
        self.availableValueArray = availableValueArray
    }
}
//************************************************************
//----------------------ViewModel for section-----------------
//************************************************************

protocol SectionItem {
    var sectionCellArray: [CellItem] { get }
    var sectionTitle: String { get }
}

class AppSettingsSectionItem: SectionItem {
    
    private let appSettings: AppSettings
    var sectionCellArray = [CellItem]()

    init(appSettings: AppSettings) {
        self.appSettings = appSettings
        
        initCellArray()
    }

    private let stopTrackingTitle = "Stop tracking"
    
    private func initCellArray() {
        let stopTrackingCell = SwitchCellItem(title: stopTrackingTitle, isOn: appSettings.isTracking)
        
        sectionCellArray.append(stopTrackingCell)
    }
    
    var sectionTitle: String {
        get {
            return "App settings"
        }
    }
}

class GpsSettingsSectionItem: SectionItem {
    
    private let gpsSettings: GPSSettings
    var sectionCellArray = [CellItem]()

    init(gpsSettings: GPSSettings) {
        self.gpsSettings = gpsSettings
        
        initCellArray()
    }
    
    private var notifyEnableTitle = "Notify enable"
    private var notifyRadiusTitle = "Notify in radius"
    private var availableRadiusValues = ["50", "100", "200", "500", "1000", "1500", "2000"]
    
    private func initCellArray() {
        let notifyEnableCell = SwitchCellItem(title: notifyEnableTitle, isOn: gpsSettings.isNotifyEnable)
        let notifyRadiusCell = PickerCellItem(
            title: notifyRadiusTitle,
            currentValue: String(gpsSettings.notifyRadius),
            availableValueArray: availableRadiusValues)
        
        sectionCellArray.append(notifyEnableCell)
        sectionCellArray.append(notifyRadiusCell)
    }
    
    var sectionTitle: String {
        get {
            return "GPS Settings"
        }
    }
    
    
}
