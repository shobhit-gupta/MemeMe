//
//  Color.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 07/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    
    enum ColorError: Error {
        case invalidColorRange
    }
    
    
    convenience init?(red: Int, green: Int, blue: Int) {

        guard case 0...255 = red, case 0...255 = green, case 0...255 = blue else {
            print(ColorError.invalidColorRange)
            return nil
        }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    
    convenience init?(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    
}
