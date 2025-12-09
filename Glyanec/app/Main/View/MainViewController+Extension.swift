import Foundation
import UIKit
import SDWebImage

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func updateItems() {
        refreshControl.endRefreshing()
        mainCV.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var productsCount: Int
        
        if viewModel.categoryProducts?.products != nil {
            productsCount = (viewModel.categoryProducts?.products.count)!
        } else {
            productsCount = 0
        }
        
        switch section {
        case 0:
            return 2
        case 1:
            return productsCount
        default:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 160, height: 50)
        case 1:
            return CGSize(width: 160, height: 280)
        default:
            return CGSize(width: collectionView.frame.size.width - 20, height: 70)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 20)
        case 1:
            return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 20)
        default:
            return UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainTopActionCellInditifer, for: indexPath) as! MainTopActionCell
            
            switch indexPath.row {
            case 0:
                cell.config(type: .lists)
            default:
                cell.config(type: .basket)
                break
            }

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainItemCollectionCellInditifer, for: indexPath) as! MainItemCell
            
            cell.config(item: (viewModel.categoryProducts?.products[indexPath.row])!)
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainTopActionCellInditifer, for: indexPath) as! MainTopActionCell
            
            cell.config(type: .discount)
            
            return cell
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.tabBarController?.selectedIndex = 2
            default:
                self.tabBarController?.selectedIndex = 3
            }
        case 1:
            let item = viewModel.categoryProducts?.products[indexPath.row]
            Coordinator.shared.goToItemDetailsViewController(id: (item?.id)!)
        default:
            break
        }
    }
}
