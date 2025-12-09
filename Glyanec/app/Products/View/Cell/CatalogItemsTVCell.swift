import UIKit
import SDWebImage

class CatalogItemsTVCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showAllButton: UIButton!
    
    @IBOutlet weak var itemsCV: UICollectionView!
    
    func config() {
//        titleLabel.text = ""
//        showAllButton.text = ""
    }
    
    @IBAction func showAllAction(_ sender: Any) {
    }
}
