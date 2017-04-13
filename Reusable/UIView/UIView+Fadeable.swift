//
//  UIView+Fadeable.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 17/12/16.
//


import Foundation
import UIKit


public extension UIView {

    public func fadeIn(duration: TimeInterval = Constant.UIView_.Fade.In.Duration,
                       delay: TimeInterval = Constant.UIView_.Fade.In.Delay,
                       completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        
        if isHidden {
            alpha = 0.0
            isHidden = false
        }
        
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
        }, completion: completion)
        
    }
    
    
    public func fadeOut(duration: TimeInterval = Constant.UIView_.Fade.Out.Duration,
                        delay: TimeInterval = Constant.UIView_.Fade.Out.Delay,
                        completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
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


public extension Constant.UIView_ {
    
    enum Fade {
        
        enum In {
            static let Duration: TimeInterval = 1.0
            static let Delay: TimeInterval = 0.0
        }
        
        enum Out {
            static let Duration: TimeInterval = 1.0
            static let Delay: TimeInterval = 0.0
        }
    }
    
}
