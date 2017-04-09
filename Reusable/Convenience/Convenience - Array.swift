//
//  Convenience - Array.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 10/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation

extension Array {

    static func filterNils(array: [Element?]) -> [Element] {
        return array
            .filter { $0 != nil }
            .map { $0! }
    }
    
    
}

