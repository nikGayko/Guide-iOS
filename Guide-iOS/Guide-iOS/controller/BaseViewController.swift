import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    //MARK: make attractive navigation bar for all VC in app
    private func setupNavigationBar() {
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    //MARK: align tab bar item center vertical in tab bar
    private func setupTabBar() {
        if let tabItem = tabBarItem {
            tabItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
            tabItem.title = nil
        }
    }
    
}
