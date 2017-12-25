import UIKit

class SightCellController: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    public var sight: Sight? {
        didSet {
            guard let sight = sight else {
                return
            }
            
            titleLabel.text = sight.title
            
            if let distance = sight.distance {
                distanceLabel.text = "\(Int(distance))"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
}
