//
//  MemeTabBarController.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 28/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit

class MemeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

}


extension MemeTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard viewController !== viewControllers?[selectedIndex] else {
            return false
        }
        if let navigationController = viewController as? UINavigationController {
            navigationController.popToRootViewController(animated: false)
        }
        return true
        
    }
    
}
