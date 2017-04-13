//
//  DynamicImageView.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 10/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit
import PureLayout


@IBDesignable
class DynamicImageView: UIView {
    
    // MARK: IBInspectables
    @IBInspectable public var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
                updateImageViewSize()
            }
        }
    }
    
    
    // MARK: Private variables and types
    internal let imageView: UIImageView = UIImageView(frame: CGRect.zero)
    
    private var shouldSetupConstraints = true
    private var imageViewSizeConstraints: [NSLayoutConstraint]?
    private var availableSpace: CGRect {
        return bounds
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
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = ArtKit.primaryColor
        addSubview(imageView)
    }
    
    
    // MARK: View Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageViewSize()
    }
    
    
    override func updateConstraints() {
        if shouldSetupConstraints {
            setImageViewSizeConstraints()
            imageView.autoCenterInSuperview()
        }
        super.updateConstraints()
        shouldSetupConstraints = false
    }
    
    
    // MARK: Private Methods
    private func remove(previous constraints: [NSLayoutConstraint]?) {
        if let constraints = constraints {
            for constraint in constraints {
                constraint.autoRemove()
            }
        }
    }
    
    
    private func setImageViewSizeConstraints() {
        remove(previous: imageViewSizeConstraints)
        imageViewSizeConstraints = imageView.autoSetDimensions(to: imageView.bounds.size)
    }
    
    
    private func updateImageViewSize() {
        if let image = image {
            imageView.bounds.size = make(size: image.size, fitIn: availableSpace.size)
            setImageViewSizeConstraints()
        }
    }
    
    
    // Modified from: http://stackoverflow.com/questions/8701751/uiimageview-change-size-to-image-size
    private func make(size originalSize: CGSize, fitIn boxSize: CGSize) -> CGSize {
        var originalSize = originalSize
        if originalSize.width == 0 { originalSize.width = boxSize.width }
        if originalSize.height == 0 { originalSize.height = boxSize.height }
        
        let widthScale = boxSize.width / originalSize.width
        let heightScale = boxSize.height / originalSize.height
        
        let scale = min(widthScale, heightScale)
        
        return CGSize(width: originalSize.width * scale, height: originalSize.height * scale)
    }
    
}









