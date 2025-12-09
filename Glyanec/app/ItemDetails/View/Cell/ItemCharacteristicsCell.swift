import UIKit
import SDWebImage

class ItemCharacteristicsCell: UITableViewCell {
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    
    func config(name: String, value: String) {
        title1Label.text = name
        title2Label.text = value
    }
}
