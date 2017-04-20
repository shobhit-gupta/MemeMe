//
//  TextField.swift
//  On The Map
//
//  Created by Shobhit Gupta on 15/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit

@IBDesignable open class TextField: UITextField {
    
    @IBInspectable public var topPadding: CGFloat = Default.TextField.Padding.Top
    @IBInspectable public var leftPadding: CGFloat = Default.TextField.Padding.Left
    @IBInspectable public var bottomPadding: CGFloat = Default.TextField.Padding.Bottom
    @IBInspectable public var rightPadding: CGFloat = Default.TextField.Padding.Right
    
    var padding: UIEdgeInsets {
        return UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
    }
    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}


public extension Default {
    enum TextField {
        enum Padding {
            static let Top: CGFloat = 0.0
            static let Left: CGFloat = 0.0
            static let Bottom: CGFloat = 0.0
            static let Right: CGFloat = 0.0
        }
    }
}
