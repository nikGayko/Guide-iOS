import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: make attractive navigation bar for all VC in app
    private func setupNavigationBar() {
        if #available(iOS 11, *) {
            navigationBar.prefersLargeTitles = true
        }
    }
}
