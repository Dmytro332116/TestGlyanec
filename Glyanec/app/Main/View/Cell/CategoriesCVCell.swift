import UIKit
import SDWebImage

class CategoriesCVCell: UICollectionViewCell, BaseAlert  {
    
    @IBOutlet weak var itemIV: UIImageView!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    func config(item: ResultCategorysListModel) {
        itemTitleLabel.text = item.name
        if let imagePath = item.image {
            setItemPreviewImageView(images: imagePath)
        } else {
            itemIV.image = UIImage(named: "placeholder")
        }
    }

    func setItemPreviewImageView(images:String) {
        if let imageCache = SDImageCache.shared.imageFromCache(forKey: images) {
            itemIV.image = imageCache
        } else {
            if let url = URL(string: images) {
                itemIV.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
//    func setFavoriteButton(fav_item: [ResultFavItemModel]?) {
//        if fav_item?.count == 0 {
//            favoriteButton.setImage(UIImage(named: "heartUnFavorite"), for: .normal)
//        } else {
//            favoriteButton.setImage(UIImage(named: "heartFavorite"), for: .normal)
//        }
//    }
}
