//
//  UICollectionView+Ease.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 26/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


extension UICollectionView {
    
    public func deselectAll(animated: Bool) {
        indexPathsForSelectedItems?.forEach {
            self.deselectItem(at: $0, animated: animated)
            reloadItems(at: [$0])
        }
    }
    
}
