import UIKit

public class AppColorTheme {
    
    public static let shared = AppColorTheme()
    
    private init() { }
    
    public var currentTheme: AvailableTheme?
    
    public func setColorThemeThroughApp(_ theme: AvailableTheme) {
        currentTheme = theme
        applyColor(theme.getTheme())
    }
    
    private func applyColor(_ theme: Theme) {
        UISwitch.appearance().onTintColor = theme.mainColor
        UITabBar.appearance().tintColor = theme.mainColor
        
//        UIWindow.appearance().tintColor = color
    }
    
}
