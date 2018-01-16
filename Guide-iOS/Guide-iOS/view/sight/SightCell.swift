import UIKit

class SightCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var sightImage: UIImageView!
    
    public var sight: Sight? {
        didSet {
            guard let sight = sight else {
                return
            }
            
            titleLabel.text = sight.title
            if let distance = sight.distance {
                distanceLabel.text = "\(Int(distance))"
            }
            if let thumbnail = sight.thumbnailImage?.image {
                sightImage.image = thumbnail
            }
            
        }
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        distanceLabel.text = ""
        sightImage.image = nil
    }
    
    private func setupUI() {
        sightImage.layer.cornerRadius = 20.0
        sightImage.layer.masksToBounds = true
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
