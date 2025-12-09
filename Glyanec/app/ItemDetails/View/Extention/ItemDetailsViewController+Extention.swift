import Foundation
import UIKit
import SDWebImage

extension ItemDetailsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
      
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.itemDetails?.products.first?.characteristics != nil {
            return (viewModel.itemDetails?.products.first?.characteristics.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let itemCharacteristicsCell = tableView.dequeueReusableCell(withIdentifier: itemCharacteristicsCell, for: indexPath) as? ItemCharacteristicsCell else {
                return UITableViewCell()
        }
        let characteristics = viewModel.itemDetails?.products.first?.characteristics[indexPath.row]
        let name = String((characteristics?.name)!)
        let value = String((characteristics?.value)!)
        
        itemCharacteristicsCell.config(name: name, value: value)

        return itemCharacteristicsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
