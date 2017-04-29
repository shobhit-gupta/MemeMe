//
//  ArtKitButton.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 07/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit
import pop

@objc protocol ArtKitButtonDelegate {
    @objc optional func tapAnimationCompletion(finished: Bool) -> Void
}


@IBDesignable
class ArtKitButton: UIButton {
    
    // MARK: Public variables and types
    public enum ArtKitButtonKind {
        case camera
        case album
        case popular
        case closeImage
    }
    
    @IBInspectable public var delegate: ArtKitButtonDelegate?
    @IBInspectable public var kind: ArtKitButtonKind = .camera { didSet { setNeedsDisplay() } }
    
    override var bounds: CGRect { didSet { setNeedsDisplay() } }
    
    override var isHighlighted: Bool {
        didSet {
            blendMode = isHighlighted ? .overlay : .normal
        }
    }
    
    override var isSelected: Bool {
        didSet {
            blendMode = isSelected ? .overlay : .normal
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.3
        }
    }
    
    
    // MARK: Private variables and types
    private enum BlendMode {
        case normal
        case overlay
    }
    
    private var blendMode: BlendMode = .normal { didSet { setNeedsDisplay() } }
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    // MARK: UIView Methods
    override func draw(_ rect: CGRect) {
        switch kind {
        case .camera:
            ArtKit.drawCameraButton(frame: bounds, isPressed: blendMode == .overlay)
        case .album:
            ArtKit.drawAlbumButton(frame: bounds, isPressed: blendMode == .overlay)
        case .popular:
            ArtKit.drawPopularButton(frame: bounds, isPressed: blendMode == .overlay)
        case .closeImage:
            ArtKit.drawCloseImage(frame: bounds)
        }
    }
    
    
    //    class func setBlendMode(of buttons: [ArtKitButton], to blendMode: BlendMode) {
    //        buttons.forEach {
    //            $0.blendMode = blendMode
    //        }
    //    }
    
    
    private func setupView() {
        backgroundColor = ArtKit.backgroundColor
        addTarget(self, action: #selector(scaleToSmall), for: [.touchDragEnter, .touchDown])
        addTarget(self, action: #selector(scaleAnimation), for: .touchUpInside)
        addTarget(self, action: #selector(scaleToDefault), for: .touchDragExit)
    }
    
}


//******************************************************************************
//                              MARK: Animations
//******************************************************************************
extension ArtKitButton {
    
    @objc fileprivate func scaleToSmall() {
        if let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY) {
            scaleAnimation.toValue = NSValue(cgSize: CGSize(width: 0.95, height: 0.95))
            layer.pop_add(scaleAnimation, forKey: "layerScaleSmallAnimation")
        }
    }
    
    
    @objc fileprivate func scaleAnimation() {
        if let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY) {
            scaleAnimation.velocity = NSValue(cgSize: CGSize(width: 3, height: 3))
            scaleAnimation.toValue = NSValue(cgSize: CGSize(width: 1, height: 1))
            scaleAnimation.springBounciness = 18.0
            scaleAnimation.completionBlock = { (animation, finished) in
                self.delegate?.tapAnimationCompletion?(finished: finished)
            }
            layer.pop_add(scaleAnimation, forKey: "layerScaleSpringAnimation")
        }
    }
    
    
    @objc fileprivate func scaleToDefault() {
        if let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY) {
            scaleAnimation.toValue = NSValue(cgSize: CGSize(width: 1, height: 1))
            layer.pop_add(scaleAnimation, forKey: "layerScaleDefaultAnimation")
        }
    }
    
}
