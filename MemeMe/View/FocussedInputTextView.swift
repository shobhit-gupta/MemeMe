//
//  FocussedInputTextView.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 11/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit

public enum OverlayType {
    case nonBlurred
    case blurred(blurView: UIVisualEffectView)
    case vibrant(blurView: UIVisualEffectView, vibrancyView: UIVisualEffectView)
}


public protocol Overlay: class{
    func setupOverlay(with style: UIBlurEffectStyle, andVibrancy isVibrant: Bool) -> OverlayType
}


public extension Overlay where Self: UIView {
    
    func setupOverlay(with style: UIBlurEffectStyle, andVibrancy isVibrant: Bool) -> OverlayType {
        guard !UIAccessibilityIsReduceTransparencyEnabled() else {
            backgroundColor = UIColor.black
            return .nonBlurred
        }
        
        return setupBlurredOverlay(with: style, andVibrancy: isVibrant)
    }
    
    
    private func setupBlurredOverlay(with style: UIBlurEffectStyle, andVibrancy isVibrant: Bool) -> OverlayType {
        let overlayType: OverlayType
        
        backgroundColor = UIColor.clear
        
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









class FocussedInputTextView: UIView {
    
    

    // MARK: Private variables and types
    fileprivate let textView: UITextView = UITextView(frame: CGRect.zero)
    fileprivate var backdrop: UIView?

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        setupView()
    }
    
}


extension FocussedInputTextView: Overlay {
    
    func setupView() {
        setupTextView()
        setupOverlay()
    }
    
    
    func setupTextView() {
        textView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        textView.text = "gjhjftd ttddyt ftk futf f"
        textView.textColor = UIColor.white
        textView.layer.cornerRadius = 2.0
    }
    
    
    func setupOverlay() {
        let overlayType = setupOverlay(with: .dark, andVibrancy: true)
        switch overlayType {
        case .nonBlurred:
            addSubview(textView)
        case .blurred(let blurView):
            blurView.contentView.addSubview(textView)
        case let .vibrant(blurView, _):
            blurView.contentView.addSubview(textView)
        }
    }
    
    
    func animate(from initialFrame: CGRect, to finalFrame: CGRect) {
        textView.frame = initialFrame
        UIView.animate(withDuration: 0.5) {
            self.textView.frame = finalFrame
        }
    }
    
}
