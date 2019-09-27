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
    
    
    // Modified from: http://stackoverflow.com/a/38003064/471960
    public func remove(indices: [Array.Index]) -> [Element] {
        return enumerated().filter { !indices.contains($0.offset) }.map { $0.element }
    }
    
    // Modified from: http://stackoverflow.com/a/36542411/471960
    public mutating func move(from fromIdx: Array.Index, to toIdx: Array.Index) {
        insert(remove(at: fromIdx), at: toIdx)
    }
    
    
    public func rearrange(from fromIdx: Array.Index, to toIdx: Array.Index) -> [Element] {
        var array = self
        array.move(from: fromIdx, to: toIdx)
        return array
    }
    
}

