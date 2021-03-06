//
//  UIView+GraphicsContext.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 20/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {
    
    public func renderToImage(atScale scale: CGFloat, afterScreenUpdates afterUpdates: Bool) -> UIImage? {
        let rectToDraw = bounds
        UIGraphicsBeginImageContextWithOptions(rectToDraw.size, false, scale)
        drawHierarchy(in: rectToDraw, afterScreenUpdates: afterUpdates)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
