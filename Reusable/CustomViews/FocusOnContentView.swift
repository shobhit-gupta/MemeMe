//
//  FocusOnContentView.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 16/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit


open class FocusOnContentView: UIView {
    
    // MARK: Public variables and types
    public var contentView = UIView(frame: CGRect.zero) { didSet { setNeedsLayout() } }
    public var availableSpace: CGRect? { didSet { setNeedsLayout() } }
    
    // Display frame for contentView inside availableSpace.
    // Override for custom contentView display
    public var displayRect: CGRect {
        let container = _availableSpace
        let initialShape: CGRect
        
        switch currentState {
        case let .start(initialRect, _, _, _):
            initialShape = initialRect ?? container
        case .display:
            initialShape = contentView.bounds
        case .end:
            initialShape = container
        }
        
        let newSize = CGSize.scale(initialShape.size, toFitIn: container.size)
        return CGRect(midPoint: CGPoint(x: container.midX, y: container.midY), size: newSize)
        
    }
    
    
    // MARK: Internal & Private variables and types
    internal var _availableSpace: CGRect {
        return availableSpace ?? bounds
    }
    
    internal enum State {
        case start(from: CGRect?, duration: TimeInterval?, options: UIViewAnimationOptions?, completion: (() -> Void)?)
        case display(duration: TimeInterval?, options: UIViewAnimationOptions?)
        case end(on: CGRect?, duration: TimeInterval?, options: UIViewAnimationOptions?, completion: (() -> Void)?)
    }
    
    internal var currentState: State = .start(from: nil, duration: nil, options: nil, completion: nil) {
        didSet {
            setNeedsLayout()
        }
    }
    
    fileprivate var _overlayType: OverlayType?
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    // MARK: Setup
    private func setupView() {
        addSubview(contentView)
    }
    
    
    
    
    // MARK: UIView Methods
    override open func layoutSubviews() {
        switch currentState {
        case let .start(initialRect, duration, options, completion):
            if let initialRect = initialRect {
                let duration = duration ?? 0.5
                let options = options ?? .curveEaseInOut
                contentView.fadeIn(from: initialRect, to: displayRect, in: duration, options: options) { (finished) in
                    if finished {
                        completion?()
                        self.currentState = .display(duration: nil, options: nil)
                    }
                }
            } else {
                contentView.frame = CGRect.zero
            }
            
        case let .display(duration, options):
            let duration = duration ?? 0.3
            let options = options ?? .curveEaseInOut
            if contentView.frame != displayRect {
                contentView.move(to: displayRect, in: duration, options: options)
            }
            
        case let .end(finalRect, duration, options, completion):
            func endCompletion() {
                completion?()
                // bug fix: Make _availableSpace equal to bounds the next time
                // the contentView is displayed irrespective of any orientation
                // changes.
                availableSpace = nil
                currentState = .start(from: nil, duration: nil, options: nil, completion: nil)
            }
            
            let duration = duration ?? 1.0
            let options = options ?? .curveEaseInOut
            
            if let finalRect = finalRect {
                contentView.fadeOut(to: finalRect, in: duration, options: options) { _ in
                    endCompletion()
                }
            } else {
                contentView.fadeOut(duration: duration, options: options) { _ in
                    endCompletion()
                }
            }
        }
    }
    
    
    // MARK: Actions
    public func start(from initialFrame: CGRect?,
                      in duration: TimeInterval? = nil,
                      with options: UIViewAnimationOptions? = nil,
                      completion: (() -> Void)? = nil) {
        currentState = .start(from: initialFrame, duration: duration, options: options, completion: completion)
    }
    
    
    public func end(on finalFrame: CGRect?,
                    in duration: TimeInterval? = nil,
                    with options: UIViewAnimationOptions? = nil,
                    completion: (() -> Void)? = nil) {
        currentState = .end(on: finalFrame, duration: duration, options: options, completion: completion)
    }
    
    
}


extension FocusOnContentView: Overlay {
    
    public var overlayType: OverlayType? {
        get {
            return _overlayType
        }
    }
    
    
    public var overlayProperties: OverlayType.Properties? {
        get {
            return overlayType?.properties
        }
        set {
            guard _overlayType == nil else {
                return
            }
            if let newValue = newValue {
                _overlayType = setupOverlay(withDesired: newValue)
                setupOverlay()
            }
        }
    }
    
    
    // Override this method to change set the type of overlay.
    private func setupOverlay() {
        if let overlayType = overlayType {
            //contentView.removeFromSuperview()
            switch overlayType {
            case .plain:
                addSubview(contentView)
            case let .blurred(_, visualEffectViews):
                if let visualEffectViews = visualEffectViews {
                    visualEffectViews.blur.contentView.addSubview(contentView)
                }
            case let .vibrant(_, visualEffectViews):
                if let visualEffectViews = visualEffectViews {
                    visualEffectViews.blur.contentView.addSubview(contentView)
                }
            }
        }
    }
    
    
}
