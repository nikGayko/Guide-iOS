import UIKit

class SettingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    @IBAction func trackingStateChanged(_ sender: UISwitch) {
        AppManager.shared.isWorking = sender.isOn
    }
}
