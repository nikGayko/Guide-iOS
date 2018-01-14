import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    final func setNavigationBar(isLarge: Bool) {
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = isLarge
        }
    }
    
}
