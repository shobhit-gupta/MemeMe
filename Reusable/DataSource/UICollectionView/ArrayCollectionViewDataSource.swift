//
//  ArrayCollectionViewDataSource.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 24/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


protocol ArrayCollectionViewDataSourceController: ArrayDataSourceController {
    associatedtype CellType: UICollectionViewCell
}


class ArrayCollectionViewDataSource<T: ArrayCollectionViewDataSourceController>: ArrayDataSource<T>, UICollectionViewDataSource {
    
    init(withController controller: T, for collectionView: UICollectionView) {
        super.init(withController: controller)
        collectionView.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? controller.source.count : 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: controller.reusableCellIdentifier, for: indexPath) as? T.CellType else {
            print("1. Couldn't find UICollectionViewCell with reusable cell identifier: \(controller.reusableCellIdentifier) or, \n2. Couldn't downcast to \(T.CellType.self)")
            return T.CellType()
        }
        
        controller.configureCell(cell, with: dataItem(at: indexPath))
        return cell
    }
   
    
}



