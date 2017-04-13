//
//  TextField.swift
//  On The Map
//
//  Created by Shobhit Gupta on 15/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import UIKit

@IBDesignable open class TextField: UITextField {
    
    @IBInspectable public var topPadding: CGFloat = 0
    @IBInspectable public var leftPadding: CGFloat = 0
    @IBInspectable public var bottomPadding: CGFloat = 0
    @IBInspectable public var rightPadding: CGFloat = 0
    
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
