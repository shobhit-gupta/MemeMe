//
//  Error_+Random.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 02/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


public extension Error_ {
    
    enum Random: Error {
        case LikelinessOutOfRange(value: Double)
        case UnexpectedStringLengths(min: Int, max: Int)
        
        var localizedDescription: String {
            var description = String(describing: self)
            switch self {
            case .LikelinessOutOfRange(let value):
                description += "Likeliness given: \(value). It must be in the range [0.0, 1.0]"
                
            case let .UnexpectedStringLengths(minLength, maxLength):
                description += "Unexpected minLength: \(minLength), maxLength: \(maxLength) encountered while generating random string"
            }
            return description
        }
    }
    
}
