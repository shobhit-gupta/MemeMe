//
//  Keyboard.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 14/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


// Modified from: http://stackoverflow.com/a/21284310/471960
public func parseKeyboard(_ notification: Notification, withRespectTo view: UIView) ->
    (animationDuration: TimeInterval, beginFrame: CGRect, endFrame: CGRect, animationOptions: UIViewAnimationOptions)? {
        
        guard let userInfo = notification.userInfo else {
            return nil
        }
        
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return nil
        }
        
        guard var beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return nil
        }
        
        guard var endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return nil
        }
        
        guard let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
            return nil
        }
        
        let animationOptions = UIViewAnimationOptions(rawValue: animationCurve << 16)
        
        beginFrame = view.convert(screenRect: beginFrame)
        endFrame = view.convert(screenRect: endFrame)
        
        return (animationDuration: duration, beginFrame: beginFrame, endFrame: endFrame, animationOptions: animationOptions)
    
}


