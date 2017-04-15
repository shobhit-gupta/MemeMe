//
//  UIView+Animations.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 14/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {
    
    
    public func fadeIn(from newFrame: CGRect,
                       duration: TimeInterval = Default.UIView_.Fade.In.Duration,
                       delay: TimeInterval = Default.UIView_.Fade.In.Delay,
                       completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        
        isHidden = true
        frame = newFrame
        fadeIn(duration: duration, delay: delay, completion: completion)
    }
    
    
    public func animate(to newFrame: CGRect,
                        in duration: TimeInterval,
                        delay: TimeInterval,
                        completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            self.frame = newFrame
        }, completion: completion)
        
    }
    
    
    public func fadeIn(from initialFrame: CGRect,
                        to finalFrame: CGRect,
                        in duration: TimeInterval,
                        completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        
        alpha = 0.0
        isHidden = false
        frame = initialFrame
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
            self.frame = finalFrame
        }, completion: completion)
    
    }
    
    
    public func fadeOut(to finalFrame: CGRect,
                        in duration: TimeInterval,
                        completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
            self.frame = finalFrame
        }, completion: completion)
        
    }
    
    
    
    
}
