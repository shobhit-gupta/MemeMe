//
//  UIImage+Ease.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 20/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
    // Modified from: http://stackoverflow.com/a/8443937/471960
    public func crop(to rect: CGRect, scale: CGFloat = UIScreen.main.scale, orientation: UIImageOrientation? = nil) -> UIImage? {
        var croppedImage: UIImage? = nil
        if let cgImage = cgImage?.cropping(to: rect) {
            croppedImage = UIImage(cgImage: cgImage, scale: scale, orientation: orientation ?? imageOrientation)
        }
        return croppedImage
    }
    
}
