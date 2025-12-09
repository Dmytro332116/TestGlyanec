import UIKit
import SDWebImage

protocol BasketItemCellDelegate: class {
    func removeItem(row: Int, itemTitle: String)
}

class BasketItemCell: UITableViewCell {
    
    @IBOutlet weak var itemIV: UIImageView!
    
    @IBOutlet weak var favoriteB: UIButton!
    
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var sumPriceL: UILabel!
    @IBOutlet weak var counterL: UILabel!
    
    weak var delegate: BasketItemCellDelegate?
    var itemIndex: Int? = nil
    
    func config(item: ItemBasketModel, row: Int) {
        itemIndex = row
        titleL.text = item.title

        let price = item.safePrice
        let qty = max(item.safeQty, 1)
        priceL.text = String(format: "%@ %@", String(price), "₴")
        counterL.text = String(qty)
        sumPriceL.text = String(format: "%@ %@", String(price * Double(qty)), "₴")

        let preview = item.displayImage ?? ""
        setItemPreviewImageView(image: preview)
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
    
    @IBAction func removeItemBAction(_ sender: Any) {
        guard let row = itemIndex else { return }
        self.delegate?.removeItem(row: row, itemTitle: titleL.text ?? "")
    }

}
