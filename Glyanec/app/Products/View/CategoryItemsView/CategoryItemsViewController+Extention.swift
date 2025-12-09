import Foundation
import UIKit
import SDWebImage

extension CategoryItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func updateItems() {
        refreshControl.endRefreshing()
        categoryItemsVCV.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.categoryProducts?.products != nil {
            return (viewModel.categoryProducts?.products.count)!
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 160, height: 260)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainItemCollectionCellInditifer, for: indexPath) as! MainItemCell
        
        cell.config(item: (viewModel.categoryProducts?.products[indexPath.row])!)
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.categoryProducts?.products[indexPath.row]
        Coordinator.shared.goToItemDetailsViewController(id: (item?.id)!)
    }
}
