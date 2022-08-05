
import UIKit

class OverViewTableViewCell: UITableViewCell {

    @IBOutlet weak var overViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        overViewLabel.font = .systemFont(ofSize: 15, weight: .semibold)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
