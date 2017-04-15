//
//  FocusOnTextView.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 11/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit


class FocusOnTextView: UIView {
    
    // MARK: Public variables and types
    public let textView: UITextView = UITextView(frame: CGRect.zero)
    

    // MARK: Private variables and types
    fileprivate enum State {
        case start(from: CGRect?)
        case display
        case end(on: CGRect?)
    }
    
    fileprivate var currentState: State = .start(from: nil) {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    fileprivate var availableHeight: CGFloat!
    
    fileprivate var availableSpace: CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: availableHeight))
    }
    
    fileprivate var displayRect: CGRect {
        let container = availableSpace
        let midPoint = CGPoint(x: container.midX, y: container.midY)
        let width = container.width - 16.0
        let height = min(100.0 + 0.1 * availableHeight, availableHeight)
        return CGRect(x: midPoint.x - width / 2, y: midPoint.y - height / 2, width: width, height: height)
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
        availableHeight = bounds.height
        setupView()
    }
    
    
    override func layoutSubviews() {
        switch currentState {
        case .start(let initialRect):
            if let initialRect = initialRect {
                textView.fadeIn(from: initialRect, to: displayRect, in: 1.0) { (finished) in
                    if finished {
                        self.currentState = .display
                    }
                }
            } else {
                textView.frame = CGRect.zero
            }
            
        case .display:
            if textView.frame != displayRect {
                textView.animate(to: displayRect, in: 1.0, delay: 0.0)
            }
            
        case .end(let finalRect):
            if let finalRect = finalRect {
                textView.fadeOut(to: finalRect, in: 1.0) { _ in
                    self.currentState = .start(from: nil)
                }
            } else {
                textView.fadeOut(duration: 1.0, delay: 0.0) { _ in
                    self.currentState = .start(from: nil)
                }
            }
        }
    }
    
    
    
    public func start(from initialFrame: CGRect?) {
        currentState = .start(from: initialFrame)
    }
    
    
    public func end(on finalFrame: CGRect?) {
        currentState = .end(on: finalFrame)
    }
    
}


extension FocusOnTextView: Overlay {
    
    func setupView() {
        setupTextView()
        setupOverlay()
    }
    
    
    func setupTextView() {
        textView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        textView.textColor = UIColor.white
        textView.layer.cornerRadius = 2.0
        textView.returnKeyType = .done
        textView.keyboardAppearance = .dark
    }
    
    
    func setupOverlay() {
        let overlayType = setupOverlay(with: .dark, andVibrancy: true)
        switch overlayType {
        case .plain:
            addSubview(textView)
        case .blurred(let blurView):
            blurView.contentView.addSubview(textView)
        case let .vibrant(blurView, _):
            blurView.contentView.addSubview(textView)
        }
    }
    
    
    func animate(from initialFrame: CGRect, to finalFrame: CGRect) {
        textView.fadeIn(from: initialFrame, to: finalFrame, in: 1.0)
    }
    
}

























/*
 
 
 
 // MARK: Public variables and types
 public let textView = UITextView(frame: CGRect.zero)
 public var startFrame: CGRect?
 
 
 // MARK: Private variables and types
 fileprivate let contentStackView = UIStackView(frame: CGRect.zero)
 fileprivate let textViewStackView = UIStackView(frame: CGRect.zero)
 
 
 // MARK: Initializers
 init(frame: CGRect, textViewStartFrame: CGRect?) {
 startFrame = textViewStartFrame
 super.init(frame: frame)
 setupView()
 }
 
 
 required init?(coder aDecoder: NSCoder) {
 startFrame = nil
 super.init(coder: aDecoder)
 setupView()
 }
 
 
 public func start() {
 subscribeToNotifications()
 textView.becomeFirstResponder()
 }
 
 
 public func end() {
 
 }
 
 
 }
 
 
 extension FocusOnTextView: Overlay {
 
 fileprivate func setupView() {
 setupContentStackView()
 setupTextViewStackView()
 setupTextView()
 setupOverlay()
 }
 
 
 private func setupContentStackView() {
 contentStackView.frame = bounds
 contentStackView.axis = .vertical
 contentStackView.alignment = .center
 addSubview(contentStackView)
 contentStackView.autoPinEdges(toSuperviewMarginsExcludingEdge: .bottom)
 }
 
 
 private func setupTextViewStackView() {
 textViewStackView.axis = .horizontal
 textViewStackView.alignment = .center
 contentStackView.addArrangedSubview(textViewStackView)
 textViewStackView.autoMatch(.width, to: .width, of: contentStackView)
 //textViewStackView.autoAlignAxis(.vertical, toSameAxisOf: contentStackView)
 //        textViewStackView.autoMatch(.width, to: .width, of: contentStackView)
 }
 
 
 private func setupTextView() {
 textView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
 textView.textColor = UIColor.white
 textView.layer.cornerRadius = 2.0
 textView.returnKeyType = .done
 textView.keyboardAppearance = .dark
 
 //textView.autoMatch(.width, to: .width, of: contentStackView, withOffset: 16.0)
 //        textView.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: 16.0)
 //        textView.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: 16.0)
 //        textView.autoAlignAxis(.horizontal, toSameAxisOf: contentView)
 }
 
 
 private func setupOverlay() {
 let overlayType = setupOverlay(with: .dark, andVibrancy: true)
 switch overlayType {
 case .plain:
 addSubview(textView)
 case .blurred(let blurView):
 blurView.contentView.addSubview(textView)
 case let .vibrant(blurView, _):
 blurView.contentView.addSubview(textView)
 }
 }
 
 
 
 
 
 func subscribeToNotifications() {
 NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
 }
 
 
 func unsubscribeFromNotifications() {
 NotificationCenter.default.removeObserver(self)
 }
 
 
 func keyboardWillShow(_ notification: Notification) {
 // Set contentStackView constraints
 let availableHeight = bounds.height - getKeyboardHeight(notification)
 contentStackView.frame.size.height = availableHeight
 textViewStackView.frame.size.height = min(100.0 + 0.1 * availableHeight, availableHeight)
 
 
 let midPoint = convert(CGPoint(x: contentStackView.frame.midX, y: contentStackView.frame.midY), to: self)
 let width = contentStackView.frame.width - 16.0
 let height = min(100.0 + 0.1 * availableHeight, availableHeight)
 let newFrame = CGRect(x: midPoint.x - width / 2, y: midPoint.y - height / 2, width: width, height: height)
 
 //let edgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
 
 // Start animation process
 //textView.frame = contentStackView.convert(textViewStackView.frame, to: self)
 //textViewStackView.addArrangedSubview(textView)
 let duration = getKeyboardAnimationDuration(notification)
 
 textView.isHidden = true
 textView.frame = startFrame!
 textView.fadeIn(duration: 1.0, delay: 0.0) { (finished) in
 if finished {
 UIView.animate(withDuration: 1.0) {
 self.textView.frame =               newFrame
 }
 }
 
 }
 
 //        if let startFrame = startFrame {
 //            textView.animate(from: startFrame, to: textViewStackView.frame, in: duration) { (finished) in
 //                if finished {
 //                    self.textViewStackView.addArrangedSubview(self.textView)
 //                }
 //            }
 //        } else {
 //            textView.fadeIn(from: textViewStackView.frame, duration: 0.6 * duration, delay: 0.4 * duration) { (finished) in
 //                if finished {
 //                    self.textViewStackView.addArrangedSubview(self.textView)
 //                }
 //            }
 //        }
 }
 
 
 //    func keyboardWillChangeFrame(_ notification: Notification) {
 //
 //    }
 
 
 
 
 }
 
 
 

 
 */
