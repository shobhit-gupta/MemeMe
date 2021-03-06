//
//  SelectableMutableArrayCollectionViewDataSource.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 28/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit

// Note: Ensure that cells are not moved when in selected state.
// In selected state set UICollectionViewController's
// installsStandardGestureForInteractiveMovement property to false.

protocol SelectableItem: class {
    var isSelected: Bool { get set }
}


protocol SelectableMutableArrayCollectionViewDataSourceController: MutableArrayCollectionViewDataSourceController {
    associatedtype ElementType : SelectableItem
    var indexPathForSelectedItems: [IndexPath] { get set }
}


class SelectableMutableArrayCollectionViewDataSource<T: SelectableMutableArrayCollectionViewDataSourceController>: MutableArrayCollectionViewDataSource<T> {
    
    func selectItem(in collectionView: UICollectionView?,
                    at indexPath: IndexPath,
                    doesCollectionViewKnow: Bool = Default.CollectionView.DoesKnow) {
        
        let item = dataItem(at: indexPath)
        item.isSelected = true
        controller.indexPathForSelectedItems.append(indexPath)
        if !doesCollectionViewKnow {
            collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: Default.CollectionView.ScrollPosition)
        }
    }
    
    
    func deselectItem(in collectionView: UICollectionView?,
                      at indexPath: IndexPath,
                      doesCollectionViewKnow: Bool = Default.CollectionView.DoesKnow) {
        
        let item = dataItem(at: indexPath)
        item.isSelected = false
        controller.indexPathForSelectedItems = controller.indexPathForSelectedItems.filter { $0 != indexPath }
        if !doesCollectionViewKnow {
            collectionView?.deselectItem(at: indexPath, animated: true)
        }
    }
    
    
    func selectAllItems(in collectionView: UICollectionView?,
                        section: Int = Default.CollectionView.Section,
                        doesCollectionViewKnow: Bool = Default.CollectionView.DoesKnow) {
        
        stride(from: 0, to: controller.source.count, by: 1).forEach {
            controller.source[$0].isSelected = true
            let indexPath = IndexPath(row: $0, section: section)
            controller.indexPathForSelectedItems.append(indexPath)
            if !doesCollectionViewKnow {
                collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: Default.CollectionView.ScrollPosition)
            }
        }
    }
    
    
    func deSelectAllItems(in collectionView: UICollectionView?,
                          doesCollectionViewKnow: Bool = Default.CollectionView.DoesKnow) {
        
        controller.indexPathForSelectedItems.forEach {
            let item = dataItem(at: $0)
            item.isSelected = false
        }
        controller.indexPathForSelectedItems.removeAll()
        if !doesCollectionViewKnow {
            collectionView?.deselectAll(animated: true)
        }
    }
    
    
    func deleteSelectedItems(in collectionView: UICollectionView?,
                             doesCollectionViewKnow: Bool = Default.CollectionView.DoesKnow,
                             completion: ((Bool) -> Void)? = nil) {
        
        collectionView?.performBatchUpdates({
            // Remove selected items from data source
            self.controller.source = self.controller.source.remove(indices: self.controller.indexPathForSelectedItems.map{ $0.item })
            
            if !doesCollectionViewKnow {
                collectionView?.deleteItems(at: self.controller.indexPathForSelectedItems)
            }
            
            self.controller.indexPathForSelectedItems.removeAll()
            
        }, completion: completion)
        
    }
    
    
}


public extension Default {
    enum CollectionView {
        static let DoesKnow = false
        static let ScrollPosition: UICollectionViewScrollPosition = .init(rawValue: 0)
        static let Section = 0
    }
}


