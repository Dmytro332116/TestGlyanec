import Foundation
import UIKit
import SDWebImage

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.categories!.count
        switch section {
        case 0:
            return 10
        default:
            return 78
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 78
        default:
            return 78
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 78
        default:
            return 78
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: catalogTVCellInditifer, for: indexPath) as! CatalogTVCell
//            cell.config(category: viewModel.categories![indexPath.row])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: catalogItemsTVCellInditifer, for: indexPath) as! CatalogItemsTVCell
//            cell.config(category: viewModel.categories![indexPath.row])
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
