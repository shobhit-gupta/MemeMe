//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 24/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit
import PureLayout


class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlay: OverlayView!
    
    fileprivate let selectionBorder: CGFloat = 2.0
    
    override var isSelected: Bool {
        didSet {
            overlay.isHidden = !isSelected
            imageView.layer.borderWidth = isSelected ? selectionBorder : 0
        }
    }
    
    
    // MARK: Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        imageView.layer.borderColor = ArtKit.secondaryColor.cgColor
        isSelected = false
    }
    
    override func prepareForReuse() {
        isSelected = false
    }
    
}


//******************************************************************************
//                              MARK: Setup
//******************************************************************************
extension MemeCollectionViewCell {
    
    fileprivate func setupView() {
        setupOverlay()
        setupOverlayConstraints()
    }
    
    
    private func setupOverlay() {
//        let properties = OverlayType.Properties(color: UIColor.white.withAlphaComponent(0.2), blur: nil)
        let properties = OverlayType.Properties(color: UIColor.white.withAlphaComponent(0.2), blur: OverlayType.Properties.Blur(style: .light, isVibrant: false))
        _ = overlay.setupOverlay(withDesired: properties)
        overlay.alpha = 0.5
    }
    
    private func setupOverlayConstraints() {
        overlay.autoPinEdge(.top, to: .top, of: imageView, withOffset: selectionBorder)
        overlay.autoPinEdge(.bottom, to: .bottom, of: imageView, withOffset: -selectionBorder)
        overlay.autoPinEdge(.left, to: .left, of: imageView, withOffset: selectionBorder)
        overlay.autoPinEdge(.right, to: .right, of: imageView, withOffset: -selectionBorder)
    }
    
}
