import UIKit
import SDWebImage

class CatalogTVCell: UITableViewCell {
    
    @IBOutlet weak var itemIV: UIImageView!
    @IBOutlet weak var arrowIV: UIImageView!
       
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var counterL: UILabel!
    
    func config(category: ResultCategorysListModel) {
        titleL.text = category.name
        counterL.text = category.count
        
        setItemPreviewImageView(image: category.image!)
    }
    
    func setItemPreviewImageView(image:String) {
        if let imageCache = SDImageCache.shared.imageFromCache(forKey: image) {
            itemIV.image = imageCache
        } else {
            if let url = URL(string: image) {
                itemIV.sd_setImage(with: url, completed: nil)
            }
        }
    }
}
