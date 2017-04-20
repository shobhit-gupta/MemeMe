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
    
    public func move(to newFrame: CGRect,
                     in duration: TimeInterval = Default.UIView_.Move.Duration,
                     delay: TimeInterval = Default.UIView_.Move.Delay,
                     options: UIViewAnimationOptions = Default.UIView_.Move.AnimationOptions,
                     completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            self.frame = newFrame
        }, completion: completion)
        
    }
    
    
    public func fadeIn(from initialFrame: CGRect,
                       to finalFrame: CGRect? = nil,
                       in duration: TimeInterval,
                       delay: TimeInterval = Default.UIView_.Fade.In.Delay,
                       options: UIViewAnimationOptions = Default.UIView_.Fade.In.AnimationOptions,
                       completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        alpha = 0.0
        isHidden = false
        frame = initialFrame
        
        if let finalFrame = finalFrame {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
                self.alpha = 1.0
                self.frame = finalFrame
            }, completion: completion)
        
        } else {
            fadeIn(duration: duration, delay: delay, options: options, completion: completion)
        }
    
    }
    
    
    public func fadeOut(to finalFrame: CGRect,
                        in duration: TimeInterval,
                        delay: TimeInterval = Default.UIView_.Fade.Out.Delay,
                        options: UIViewAnimationOptions = Default.UIView_.Fade.Out.AnimationOptions,
                        completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            self.alpha = 0.0
            self.frame = finalFrame
        }, completion: completion)
        
    }
    
}


public extension Default.UIView_ {
    
    enum Move {
        static let Duration: TimeInterval = 1.0
        static let Delay: TimeInterval = 0.0
        static let AnimationOptions: UIViewAnimationOptions = .curveEaseInOut
    }
    
}
