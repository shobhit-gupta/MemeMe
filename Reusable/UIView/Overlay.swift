//
//  Overlay.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 13/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit


public enum OverlayType {
    case plain
    case blurred(blurView: UIVisualEffectView)
    case vibrant(blurView: UIVisualEffectView, vibrancyView: UIVisualEffectView)
}


public protocol Overlay: class {
    func setupOverlay(with style: UIBlurEffectStyle, andVibrancy isVibrant: Bool) -> OverlayType
}


public extension Overlay where Self: UIView {
    
    func setupOverlay(with style: UIBlurEffectStyle, andVibrancy isVibrant: Bool) -> OverlayType {
        guard !UIAccessibilityIsReduceTransparencyEnabled() else {
            backgroundColor = Default.Overlay.PlainBackgroundColor
            return .plain
        }
        return setupBlurredOverlay(with: style, andVibrancy: isVibrant)
    }
    
    
    private func setupBlurredOverlay(with style: UIBlurEffectStyle, andVibrancy isVibrant: Bool) -> OverlayType {
        let overlayType: OverlayType
        backgroundColor = Default.Overlay.BackgroundColor
        
        // Blur
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        
        // Vibrancy
        if isVibrant {
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurView.contentView.addSubview(vibrancyView)
            overlayType = .vibrant(blurView: blurView, vibrancyView: vibrancyView)
        } else {
            overlayType = .blurred(blurView: blurView)
        }
        
        return overlayType
    }
    
}


public extension Default {
    enum Overlay {
        static let PlainBackgroundColor = ArtKit.primaryColor  // UIColor.black
        static let BackgroundColor = ArtKit.primaryColor.withAlphaComponent(0.5)    // UIColor.clear
    }
}

