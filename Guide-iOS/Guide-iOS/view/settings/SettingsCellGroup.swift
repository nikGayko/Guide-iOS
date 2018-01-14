import UIKit
import SwiftyBeaver

class SwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchIndicator: UISwitch!
    
    var item: SwitchCellItem? {
        didSet {
            guard let item = item else {
                SwiftyBeaver.warning("No Model Item")
                return
            }
            
            titleLabel.text = item.title
            switchIndicator.isOn = item.isOn
        }
    }
    
    @IBAction func valueDidChange(_ sender: UISwitch) {
        item?.listener?(sender.isOn)
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
    @IBOutlet weak var detailLabel: UILabel!
    
    var item: PickerCellItem? {
        didSet {
            guard let item = item else {
                SwiftyBeaver.warning("No Model Item")
                return
            }
            
            titleLabel.text = item.title
            detailLabel.text = item.currentValue
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
