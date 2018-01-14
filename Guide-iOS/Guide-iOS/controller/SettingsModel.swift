import Foundation
import UIKit
//************************************************************
//----------------------ViewModel for cell--------------------
//************************************************************
enum SettingsCellType {
    case binary
    case picker
}

protocol CellItem {
    var type: SettingsCellType { get }
    var isSelectable: Bool { get }
}

protocol SelectableCellItem: CellItem {
    func valueDidChange(newValue: String)
    func getCurrentValue() -> String?
    var availableValueArray: [String] { get }
}

extension SelectableCellItem {
    var isSelectable: Bool {
        return true
    }
}

class SwitchCellItem: CellItem {
    let title: String
    var isOn: Bool
    var listener: ((Bool) -> Void)?
    
    init(title: String, isOn: Bool, valueChangeListener: ((Bool) -> Void)? = nil) {
        self.isOn = isOn
        self.title = title
        self.listener = valueChangeListener
    }
    
    //MARK: - Cell item protocol
    var type: SettingsCellType {
        return .binary
    }
    
    var isSelectable: Bool {
        return false
    }
}

class PickerCellItem: SelectableCellItem {
    let title: String
    var listener: ((String) -> Void)?
    var currentValue: String?
    
    init(title: String, currentValue: String, availableValueArray: [String], valueChangeListener: ((String) -> Void)? = nil) {
        self.title = title
        self.currentValue = currentValue
        self.availableValueArray = availableValueArray
        self.listener = valueChangeListener
    }
    
    //MARK: - Cell item protocol
    var type: SettingsCellType {
        return .picker
    }
    
    func valueDidChange(newValue: String) {
        currentValue = newValue
        listener?(newValue)
    }
    
    var availableValueArray: [String]
    
    func getCurrentValue() -> String? {
        return currentValue
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
        let stopTrackingCell = SwitchCellItem(title: stopTrackingTitle, isOn: appSettings.isTracking) { [weak self] newValue in
            self?.appSettings.isTracking = newValue
        }
        
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
        let notifyEnableCell = SwitchCellItem(title: notifyEnableTitle, isOn: gpsSettings.isNotifyEnable) { [weak self] newValue in
            self?.gpsSettings.isNotifyEnable = newValue
        }
        let notifyRadiusCell = PickerCellItem(
            title: notifyRadiusTitle,
            currentValue: String(gpsSettings.notifyRadius),
            availableValueArray: availableRadiusValues) { [weak self] newValue in
                if let integerValue = Int(newValue) {
                    self?.gpsSettings.notifyRadius = integerValue
                }
        }
        
        sectionCellArray.append(notifyEnableCell)
        sectionCellArray.append(notifyRadiusCell)
    }
    
    var sectionTitle: String {
        get {
            return "GPS Settings"
        }
    }
    
    
}
