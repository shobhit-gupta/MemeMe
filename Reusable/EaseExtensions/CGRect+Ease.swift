//
//  CGRect+Ease.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 15/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension CGRect {
    
    public var midPoint: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    
    public init(midPoint: CGPoint, size: CGSize) {
        let origin = CGPoint(x: midPoint.x - size.width / 2, y: midPoint.y - size.height / 2)
        self.init(origin: origin, size: size)
    }
    
    
    public func scaleBy(factor: CGFloat) -> CGRect {
        return CGRect(midPoint: midPoint, size: CGSize(width: width * factor, height: height * factor))
    }
    
}
