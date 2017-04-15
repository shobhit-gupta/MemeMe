//
//  CGSize+Ease.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 13/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension CGSize {
    
    // Modified from: http://stackoverflow.com/questions/8701751/uiimageview-change-size-to-image-size
    public static func scale(_ originalSize: CGSize, toFitIn boxSize: CGSize) -> CGSize {
        var originalSize = originalSize
        if originalSize.width == 0 { originalSize.width = boxSize.width }
        if originalSize.height == 0 { originalSize.height = boxSize.height }
        
        let widthScale = boxSize.width / originalSize.width
        let heightScale = boxSize.height / originalSize.height
        
        let scale = min(widthScale, heightScale)
        
        return CGSize(width: originalSize.width * scale, height: originalSize.height * scale)
    }
    
}
