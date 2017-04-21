//
//  Meme.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 20/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
    
    
    public func save(byReplacing idx: Int? = nil) -> Bool {
        var isSaved = false
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return isSaved
        }
        
        if let idx = idx,
            appDelegate.memes.indices.contains(idx) {
            
            appDelegate.memes[idx] = self
            isSaved = true
            
        } else {
            appDelegate.memes.append(self)
            isSaved = true
        }
        
        print(appDelegate.memes)
        print("============================================")
        return isSaved
        
    }
    
    
}
