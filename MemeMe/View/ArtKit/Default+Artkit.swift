//
//  Default+Artkit.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 02/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension Default {
    
    enum Artkit_ {
        
        enum Button {
            
            enum ScaleToSmall {
                static let Size = CGSize(width: 0.95, height: 0.95)
                static let Key = "layerScaleSmallAnimation"
            }
            
            enum ScaleToDefaultWithSpring {
                static let Velocity = CGSize(width: 3, height: 3)
                static let Size = CGSize(width: 1.0, height: 1.0)
                static let SpringBounciness: CGFloat = 18.0
                static let Key = "layerScaleDefaultSpringAnimation"
            }
            
            enum ScaleToDefault {
                static let Size = CGSize(width: 1.0, height: 1.0)
                static let Key = "layerScaleDefaultAnimation"
            }
        }
        
        
        enum Bar {
            
            enum Shadow {
                static let Color: CGColor = ArtKit.shadowOfPrimaryColor.cgColor
                static let OffsetNavBar = CGSize(width: 0.0, height: 0.0)
                static let OffsetTabBar = CGSize(width: 0.0, height: 0.0)
                static let Radius: CGFloat = 4.0
                static let Opacity: Float = 1.0
                static let MasksToBounds = false
            }
        }
    }
    
    
    
}
