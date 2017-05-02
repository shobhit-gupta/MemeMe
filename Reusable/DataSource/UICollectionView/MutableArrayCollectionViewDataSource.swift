//
//  MutableArrayCollectionViewDataSource.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 27/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


protocol MutableArrayCollectionViewDataSourceController: MutableArrayDataSourceController {
    associatedtype CellType: UICollectionViewCell
}


class MutableArrayCollectionViewDataSource<T: MutableArrayCollectionViewDataSourceController>: ArrayDataSource<T>, UICollectionViewDataSource {
    
    init(withController controller: T, for collectionView: UICollectionView) {
        super.init(withController: controller)
        collectionView.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? controller.source.count : Default.ArrayDataSource.ItemsCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: controller.reusableCellIdentifier, for: indexPath) as? T.CellType else {
            let error = Error_.ArrayDataSource.DequeCellFailed(identifier: controller.reusableCellIdentifier, cellType: T.CellType.self)
            print(error.localizedDescription)
            return T.CellType()
        }
        
        controller.configureCell(cell, with: dataItem(at: indexPath))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        controller.source.move(from: sourceIndexPath.item, to: destinationIndexPath.item)
        // Fix: Resolves the issue with moving cells of varying sizes.
        collectionView.reloadItems(at: [sourceIndexPath])
    }
    
    
}


