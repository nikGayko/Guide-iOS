import UIKit
import SwiftyBeaver

class SwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchIndicator: UISwitch!
    
    var item: SwitchCellItem? {
        didSet {
            guard let switchModelItem = item else {
                SwiftyBeaver.warning("No Model Item")
                return
            }
            
            titleLabel.text = switchModelItem.title
            switchIndicator.isOn = switchModelItem.isOn
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

class PickerCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: PickerCellItem?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
