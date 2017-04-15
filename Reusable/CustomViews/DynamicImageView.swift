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
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    private func setupView() {
        imageView.contentMode = Default.DynamicImageView.ContentMode
        imageView.backgroundColor = Default.DynamicImageView.BackgroundColor
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
            imageView.bounds.size = CGSize.scale(image.size, toFitIn: availableSpace.size)
            setImageViewSizeConstraints()
        }
    }
    
    
}


extension Default {
    enum DynamicImageView {
        static let ContentMode: UIViewContentMode = .scaleAspectFit
        static let BackgroundColor: UIColor = ArtKit.primaryColor
    }
}








