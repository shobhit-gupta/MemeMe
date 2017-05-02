//
//  ArtKit+Appearance.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 24/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension ArtKit {
    
    public class func setupAppearance() {
        setupNavBarAppearance()
        setupTabBarAppearance()
    }
    
    
    public class func setupTabBarAppearance() {
        let appearance = UITabBar.appearance()
        appearance.barTintColor = ArtKit.primaryColor
        appearance.tintColor = ArtKit.secondaryColor
        appearance.barStyle = .black
        appearance.isShadowPresent = true
    }
    
    
    public class func setupNavBarAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = ArtKit.primaryColor
        appearance.tintColor = ArtKit.secondaryColor
        // To set the status bar style to lightcontent when the navigation
        // controller displays a navigation bar.
        appearance.barStyle = .black
        appearance.isShadowPresent = true
       
    }
    
}


extension UINavigationBar {
    
    var isShadowPresent: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue {
                layer.shadowColor = Default.Artkit_.Bar.Shadow.Color
                layer.shadowOffset = Default.Artkit_.Bar.Shadow.OffsetNavBar
                layer.shadowRadius = Default.Artkit_.Bar.Shadow.Radius
                layer.shadowOpacity = Default.Artkit_.Bar.Shadow.Opacity
                layer.masksToBounds = Default.Artkit_.Bar.Shadow.MasksToBounds
            } else {
                layer.shadowColor = nil
                layer.shadowOpacity = 0.0
                layer.masksToBounds = true
            }
        }
    }
    
}


extension UITabBar {
    
    var isShadowPresent: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue {
                layer.shadowColor = Default.Artkit_.Bar.Shadow.Color
                layer.shadowOffset = Default.Artkit_.Bar.Shadow.OffsetTabBar
                layer.shadowRadius = Default.Artkit_.Bar.Shadow.Radius
                layer.shadowOpacity = Default.Artkit_.Bar.Shadow.Opacity
                layer.masksToBounds = Default.Artkit_.Bar.Shadow.MasksToBounds
            } else {
                layer.shadowColor = nil
                layer.shadowOpacity = 0.0
                layer.masksToBounds = true
            }
        }
    }
    
}
