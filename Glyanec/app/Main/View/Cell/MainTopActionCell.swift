import UIKit
import SDWebImage

public enum MainTopActionType {
    case lists
    case basket
    case discount
}


class MainTopActionCell: UICollectionViewCell, BaseAlert  {
    
    @IBOutlet weak var actionIV: UIImageView!
    @IBOutlet weak var actionL: UILabel!
    
    func config(type: MainTopActionType) {
        switch type {
        case .lists:
            actionL.text = "Мої списки"
            actionIV.image = #imageLiteral(resourceName: "heartWhiteIcon")
        case .basket:
            actionL.text = "Мої замовлення"
            actionIV.image = #imageLiteral(resourceName: "basketWhiteIcon")
        default:
            actionL.text = "Товари зі знижкою"
            actionIV.image = #imageLiteral(resourceName: "pesentWhiteIcon")
            break
        }
    }
}
