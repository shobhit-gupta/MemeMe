//
//  Overlay.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 13/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit


public enum OverlayType {

    public struct VisualEffectViews {
        let blur: UIVisualEffectView
        let vibrancy: UIVisualEffectView?
    }
    
    public struct Properties {
        public struct Blur {
            let style: UIBlurEffectStyle
            let isVibrant: Bool
        }
        
        let color: UIColor
        let blur: Blur?
    }
    
    case plain(with: Properties)
    case blurred(with: Properties, visualEffectViews: VisualEffectViews?)
    case vibrant(with: Properties, visualEffectViews: VisualEffectViews?)
    
    var properties: Properties {
        switch self {
        case .plain(let properties), .blurred(let properties, _), .vibrant(let properties, _):
            return properties
        }
    }
    
    var visualEffectViews: VisualEffectViews? {
        switch self {
        case .plain:
            return nil
        case .blurred(_, let visualEffectViews), .vibrant(_, let visualEffectViews):
            return visualEffectViews
        }
    }
    
}


public protocol Overlay: class {
    func setupOverlay(withDesired properties: OverlayType.Properties) -> OverlayType
}


public extension Overlay where Self: UIView {
    
    func setupOverlay(withDesired properties: OverlayType.Properties) -> OverlayType {
        
        let overlayType: OverlayType
        backgroundColor = properties.color
        
        guard !UIAccessibilityIsReduceTransparencyEnabled() else {
            return .plain(with: OverlayType.Properties(color: properties.color, blur: nil))
        }
        
        if let blurProperties = properties.blur {
            let blurEffect = UIBlurEffect(style: blurProperties.style)
            let blurView = setupBlurView(with: blurEffect)
            
            if blurProperties.isVibrant {
                let vibrancyView = setupVibrancyView(with: blurEffect, in: blurView)
                overlayType = .blurred(with: properties,
                                       visualEffectViews: OverlayType.VisualEffectViews(blur: blurView, vibrancy: vibrancyView))
            } else {
                overlayType = .blurred(with: properties,
                                       visualEffectViews: OverlayType.VisualEffectViews(blur: blurView, vibrancy: nil))
            }
            
        } else {
            overlayType = .plain(with: properties)
        }
        
        return overlayType
    }
    
    
    private func setupBlurView(with effect: UIBlurEffect) -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        return blurView
    }
    
    
    private func setupVibrancyView(with blurEffect: UIBlurEffect, in blurView: UIVisualEffectView) -> UIVisualEffectView {
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurView.contentView.addSubview(vibrancyView)
        return vibrancyView
    }
    
}


public extension Default {
    enum Overlay {
        static let BlurEffectStyle: UIBlurEffectStyle = .dark
        static let BackgroundColor = ArtKit.primaryColor.withAlphaComponent(0.5)    // UIColor.clear
    }
}

