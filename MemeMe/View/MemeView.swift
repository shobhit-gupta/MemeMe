//
//  MemeView.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 10/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit
import PureLayout


@IBDesignable
class MemeView: UIView {
    
    private var shouldSetupConstraints = true
    private var imageViewSizeConstraints: [NSLayoutConstraint]?
    
    @IBInspectable public var image: UIImage? {
        didSet {
            if let image = image {
                imageView.bounds.size = make(size: image.size, fitIn: bounds.size)
                imageView.image = image
                shouldSetupConstraints = true
                setNeedsUpdateConstraints()
            }
        }
    }
    
    fileprivate let imageView: UIImageView = UIImageView(frame: CGRect.zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit() {
        backgroundColor = UIColor.red
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = ArtKit.primaryColor
        addSubview(imageView)
    }
    
    
    override func updateConstraints() {
        if shouldSetupConstraints {
            remove(previous: imageViewSizeConstraints)
            imageViewSizeConstraints = imageView.autoSetDimensions(to: imageView.bounds.size)
            imageView.autoCenterInSuperview()
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let image = image {
            imageView.bounds.size = make(size: image.size, fitIn: bounds.size)
            shouldSetupConstraints = true
            setNeedsUpdateConstraints()
        }
    }
    
    
    private func remove(previous constraints: [NSLayoutConstraint]?) {
        if let constraints = constraints {
            for constraint in constraints {
                constraint.autoRemove()
            }
        }
    }
    
    
    fileprivate func make(size originalSize: CGSize, fitIn boxSize: CGSize) -> CGSize {
        var originalSize = originalSize
        if originalSize.width == 0 { originalSize.width = boxSize.width }
        if originalSize.height == 0 { originalSize.height = boxSize.height }
        
        let widthScale = boxSize.width / originalSize.width
        let heightScale = boxSize.height / originalSize.height
        
        let scale = min(widthScale, heightScale)
        
        return CGSize(width: originalSize.width * scale, height: originalSize.height * scale)
    }

}















