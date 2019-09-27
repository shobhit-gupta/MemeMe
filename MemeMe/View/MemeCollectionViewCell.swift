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
    
    fileprivate let selectionBorder: CGFloat = Default.GridViewCell.Selected.Border.Width
    
    override var isSelected: Bool {
        didSet {
            overlay.isHidden = !isSelected
            imageView.layer.borderWidth = isSelected ? selectionBorder : Default.GridViewCell.Unselected.Border.Width
        }
    }
    
    
    // MARK: Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        isSelected = Default.GridViewCell.Selected.OnReuse
    }
    
}


//******************************************************************************
//                              MARK: Setup
//******************************************************************************
extension MemeCollectionViewCell {
    
    fileprivate func setupView() {
        setupProperties()
        setupOverlay()
        setupOverlayConstraints()
    }
    
    private func setupProperties() {
        isSelected = Default.Meme.IsSelected
        backgroundColor = Default.GridViewCell.BackgroundColor
        imageView.layer.borderColor = Default.GridViewCell.Selected.Border.Color.cgColor//ArtKit.primaryColor.cgColor
    }
    
    private func setupOverlay() {
        let properties = OverlayType.Properties(color: Default.GridViewCell.Selected.Overlay.Color, blur: nil)
//        let properties = OverlayType.Properties(color: UIColor.white.withAlphaComponent(0.2), blur: OverlayType.Properties.Blur(style: .light, isVibrant: false))
        _ = overlay.setupOverlay(withDesired: properties)
        overlay.alpha = Default.GridViewCell.Selected.Overlay.Alpha
    }
    
    private func setupOverlayConstraints() {
        overlay.autoPinEdge(.top, to: .top, of: imageView, withOffset: selectionBorder)
        overlay.autoPinEdge(.bottom, to: .bottom, of: imageView, withOffset: -selectionBorder)
        overlay.autoPinEdge(.left, to: .left, of: imageView, withOffset: selectionBorder)
        overlay.autoPinEdge(.right, to: .right, of: imageView, withOffset: -selectionBorder)
    }
    
}
