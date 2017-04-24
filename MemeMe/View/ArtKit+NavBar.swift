//
//  ArtKit+NavBar.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 24/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension ArtKit {
    
    public class func setupNavBar() {
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = ArtKit.primaryColor
        appearance.tintColor = ArtKit.secondaryColor
        // To set the status bar style to lightcontent when the navigation
        // controller displays a navigation bar.
        appearance.barStyle = .black
    }
    
}
