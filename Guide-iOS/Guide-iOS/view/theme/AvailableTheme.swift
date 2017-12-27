import UIKit

public enum AvailableTheme {
    
    case purple
    case blue
    
    func getTheme() -> Theme {
        
        var mainColor: UIColor
        
        switch self {
        case .purple:
            mainColor = UIColor(r: 157, g: 52, b: 157)
            
        case .blue:
            mainColor = UIColor(r: 0, g: 0, b: 230)
        }
        
        return Theme(mainColor: mainColor)
    }
}
