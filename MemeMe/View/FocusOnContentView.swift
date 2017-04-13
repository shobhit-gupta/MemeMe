//
//  FocusOnContentView.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 11/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit


class FocusOnContentView: UIView {
    
    

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


extension FocusOnContentView: Overlay {
    
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
        case .plain:
            addSubview(textView)
        case .blurred(let blurView):
            blurView.contentView.addSubview(textView)
        case let .vibrant(blurView, _):
            blurView.contentView.addSubview(textView)
        }
    }
    
    
    func animate(from initialFrame: CGRect, to finalFrame: CGRect) {
        textView.isHidden = true
        self.textView.frame = initialFrame
        textView.fadeIn(duration: 0.3, delay: 0.0) { (finished) in
            if (finished) {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.textView.frame = finalFrame
                }, completion: nil)
            }
        }
        
        
    }
    
}
