//
//  String+Ease.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 15/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation

extension String {
    
    func length() -> Int {
        return self.characters.count
    }
    
    
    // http://stackoverflow.com/a/26306372/471960
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}
