//
//  UIView+Fadeable.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 17/12/16.
//


import Foundation
import UIKit


public extension UIView {

    public func fadeIn(duration: TimeInterval = Default.UIView_.Fade.In.Duration,
                       delay: TimeInterval = Default.UIView_.Fade.In.Delay,
                       options: UIViewAnimationOptions = Default.UIView_.Fade.In.AnimationOptions,
                       completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        
        if isHidden {
            alpha = 0.0
            isHidden = false
        }
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            self.alpha = 1.0
        }, completion: completion)
        
    }
    
    
    public func fadeOut(duration: TimeInterval = Default.UIView_.Fade.Out.Duration,
                        delay: TimeInterval = Default.UIView_.Fade.Out.Delay,
                        options: UIViewAnimationOptions = Default.UIView_.Fade.Out.AnimationOptions,
                        completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            self.alpha = 0.0
        }, completion: completion)
        
    }
    
    
    public class func fade(out outView: UIView,
                           andHide shouldHide: Bool = true,
                           thenFadeIn inView: UIView,
                           completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        
        outView.fadeOut { _ in
            outView.isHidden = shouldHide
            inView.fadeIn(completion: completion)
        }
        
    }
    
}


public extension Default.UIView_ {
    
    enum Fade {

        enum In {
            static let Duration: TimeInterval = 1.0
            static let Delay: TimeInterval = 0.0
            static let AnimationOptions: UIViewAnimationOptions = .curveEaseInOut
        }
        
        enum Out {
            static let Duration: TimeInterval = 1.0
            static let Delay: TimeInterval = 0.0
            static let AnimationOptions: UIViewAnimationOptions = .curveEaseInOut
        }
    }
    
}
