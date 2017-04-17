//
//  UIView+Convert.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 16/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {
 
    public func convert(screenPoint: CGPoint) -> CGPoint {
        let windowPoint = window?.convert(screenPoint, from: nil) ?? screenPoint
        return convert(windowPoint, from: nil)
    }

    
    public func convert(screenRect: CGRect) -> CGRect {
        let windowRect = window?.convert(screenRect, from: nil) ?? screenRect
        return convert(windowRect, from: nil)
    }    
    
}
