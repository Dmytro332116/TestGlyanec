import Foundation
import UIKit

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteListCellInditifer, for: indexPath) as! FavoriteListTVCell
        
        switch indexPath.row {
        case 0:
            cell.titleL.text = "Створити список покупок"
            cell.countL.isHidden = true
            cell.actionIV.image = #imageLiteral(resourceName: "greenPlus")
        default:
            cell.actionIV.image = #imageLiteral(resourceName: "greenArrowRight")
            cell.config()
            break
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
