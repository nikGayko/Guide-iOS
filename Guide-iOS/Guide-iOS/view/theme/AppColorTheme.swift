import UIKit

public class AppColorTheme {
    
    public static let shared = AppColorTheme()
    
    private init() { }
    
    public var currentTheme: ThemeItems?
    
    public func setColorThemeThroughApp(_ theme: ThemeItems) {
        currentTheme = theme
        applyColor(theme.getTheme())
    }
    
    private func applyColor(_ theme: Theme) {
        UISwitch.appearance().onTintColor = theme.mainColor
        UITabBar.appearance().tintColor = theme.mainColor
        
//        UIWindow.appearance().tintColor = color
    }
    
}
