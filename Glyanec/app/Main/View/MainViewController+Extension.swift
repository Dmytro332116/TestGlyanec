import Foundation
import UIKit
import SDWebImage

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func updateItems() {
        refreshControl.endRefreshing()
        mainCV.reloadData()
        updateEmptyState()
    }

    private func updateEmptyState() {
        let productsCount = viewModel.categoryProducts?.products.count ?? 0
        if productsCount == 0 {
            let emptyLabel = UILabel(frame: mainCV.bounds)
            emptyLabel.text = "Нічого не знайдено"
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 0
            mainCV.backgroundView = emptyLabel
        } else {
            mainCV.backgroundView = nil
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let productsCount = viewModel.categoryProducts?.products.count ?? 0

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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainTopActionCellInditifer, for: indexPath) as? MainTopActionCell else { return UICollectionViewCell() }
            
            switch indexPath.row {
            case 0:
                cell.config(type: .lists)
            default:
                cell.config(type: .basket)
                break
            }

            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainItemCollectionCellInditifer, for: indexPath) as? MainItemCell else { return UICollectionViewCell() }
            if let products = viewModel.categoryProducts?.products, indexPath.row < products.count {
                cell.config(item: products[indexPath.row])
            }

            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainTopActionCellInditifer, for: indexPath) as? MainTopActionCell else { return UICollectionViewCell() }
            
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
            guard let products = viewModel.categoryProducts?.products,
                  indexPath.row < products.count,
                  let id = products[indexPath.row].id else { return }
            Coordinator.shared.goToItemDetailsViewController(id: id)
        default:
            break
        }
    }
}
