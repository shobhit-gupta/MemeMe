//
//  Array+Random.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 25/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


extension Array {
    
    public func random() -> Element {
        let randomIdx = Int.random(in: indices)
        return self[randomIdx]
    }
    
}
