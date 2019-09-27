//
//  MemeItem.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 27/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit

// MemeItem is passed by reference so that view controllers may easily (un)set
// isSelected property.
class MemeItem: SelectableItem {
    let meme: Meme
    var isSelected: Bool
    
    init(with meme: Meme, isSelected: Bool = Default.Meme.IsSelected) {
        self.meme = meme
        self.isSelected = isSelected
    }
    
    
    public func save(byReplacing idx: Int? = nil) -> Bool {
        var isSaved = false
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print(Error_.General.DowncastMismatch(for: UIApplication.shared.delegate!, as: AppDelegate.self as AnyClass as! AnyClass.Type))
            return isSaved
        }
        
        if let idx = idx,
            appDelegate.memeItems.indices.contains(idx) {
            
            appDelegate.memeItems[idx] = self
            isSaved = true
            
        } else {
            appDelegate.memeItems.append(self)
            isSaved = true
        }
        
        return isSaved
        
    }
    
}

