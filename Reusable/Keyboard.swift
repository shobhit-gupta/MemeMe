//
//  Keyboard.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 14/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public func getKeyboardHeight(_ notification: Notification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    return keyboardSize.cgRectValue.height
}


public func getKeyboardAnimationDuration(_ notification: Notification) -> TimeInterval {
    let userInfo = notification.userInfo
    let duration = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
    return duration.doubleValue as TimeInterval
}
