//
//  Array+Ease.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 10/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation

public extension Array {

    public static func filterNils(array: [Element?]) -> [Element] {
        return array
            .filter { $0 != nil }
            .map { $0! }
    }
    
    
    public func remove(indices: [Array.Index]) -> [Element] {
        return enumerated().filter { !indices.contains($0.offset) }.map { $0.element }
    }
    
}

