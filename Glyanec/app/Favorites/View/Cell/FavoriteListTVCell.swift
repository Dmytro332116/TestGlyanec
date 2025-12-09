import UIKit

class FavoriteListTVCell: UITableViewCell {
    
    @IBOutlet weak var actionIV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var countL: UILabel!
    
    func config() {
        titleL.text = "Test"
        countL.text = "10"
    }
}
