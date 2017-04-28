//
//  FocusOnTextView.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 11/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit


class FocusOnTextView: FocusOnContentView {
    
    // MARK: Public variables and types
    public var textView: UITextView {
        return contentView as! UITextView
    }
    
    public override var displayRect: CGRect {
        let container = _availableSpace
        let midPoint = container.midPoint
        let width = container.width - 16.0
        let height = min(100.0 + 0.1 * container.height, container.height)
        return CGRect(midPoint: midPoint, size: CGSize(width: width, height: height))
    }
    
    
    // MARK: Private variables and types
    fileprivate var availableHeight: CGFloat? {
        didSet {
            if let availableHeight = availableHeight,
                availableHeight >= 0 {
                availableSpace = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: availableHeight))
            } else {
                availableSpace = bounds
            }
        }
    }
    
    
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
        contentView = UITextView(frame: CGRect.zero)
        setupView()
    }
    
    
    private func setupView() {
        setupTextView()
    }
    
    
    // MARK: Actions
    override func start(from initialFrame: CGRect?,
                        in duration: TimeInterval? = nil,
                        with options: UIViewAnimationOptions? = nil,
                        completion: (() -> Void)? = nil) {
        subscribeToNotifications()
        super.start(from: initialFrame, in: duration, with: options) {
            self.textView.becomeFirstResponder()
            completion?()
        }
    }
    
    
    override func end(on finalFrame: CGRect?,
                      in duration: TimeInterval? = nil,
                      with options: UIViewAnimationOptions? = nil,
                      completion: (() -> Void)? = nil) {
        unsubscribeFromNotifications()
        super.end(on: finalFrame, in: duration, with: options, completion: completion)
    }
    
    
    // Wrapper method @objc is not supported within extensions of generic classes.
    // @objc is needed with the use of #selector when subscribing to keyboard notifications.
    @objc fileprivate func keyboardWillChangeFrameWrapper(_ notification: Notification) {
        keyboardWillChangeFrame(notification)
    }
    
    
}


//******************************************************************************
//                                  MARK: Setup
//******************************************************************************
extension FocusOnTextView {
    
    fileprivate func setupTextView() {
        textView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        textView.textColor = UIColor.white
        textView.layer.cornerRadius = 2.0
        textView.keyboardAppearance = .dark
    }

}


//******************************************************************************
//                              MARK: Keyboard
//******************************************************************************
extension FocusOnTextView {
    
    fileprivate func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrameWrapper(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    fileprivate func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    fileprivate func keyboardWillChangeFrame(_ notification: Notification) {
        updateKeyboardHeight(notification)
    }
    
    
    private func updateKeyboardHeight(_ notification: Notification) {
        if let info = parseKeyboard(notification, withRespectTo: self) {
            switch currentState {
            case let .start(initialRect, _, _, completion):
                currentState = .start(from: initialRect, duration: info.animationDuration, options: info.animationOptions, completion: completion)
            case .display:
                currentState = .display(duration: info.animationDuration, options: info.animationOptions)
            case let .end(finalRect, _, _, completion):
                currentState = .end(on: finalRect, duration: info.animationDuration, options: info.animationOptions, completion: completion)
            }
            availableHeight = info.endFrame.origin.y
            
        }
    }
    
}

















