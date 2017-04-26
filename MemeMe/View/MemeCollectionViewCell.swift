//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 24/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit


class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlay: OverlayView!
    
    override var isSelected: Bool {
        didSet {
            overlay.isHidden = !isSelected
            imageView.layer.borderWidth = isSelected ? 2 : 0
            
        }
    }
    
    
    // MARK: Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        imageView.layer.borderColor = ArtKit.highlightOfPrimaryColor.cgColor
        isSelected = false
    }
    
}


//******************************************************************************
//                              MARK: Setup
//******************************************************************************
extension MemeCollectionViewCell {
    
    fileprivate func setupView() {
        setupOverlay()
    }
    
    
    private func setupOverlay() {
//        let properties = OverlayType.Properties(color: UIColor.white.withAlphaComponent(0.2), blur: nil)
        let properties = OverlayType.Properties(color: UIColor.white.withAlphaComponent(0.2), blur: OverlayType.Properties.Blur(style: .light, isVibrant: false))
        _ = overlay.setupOverlay(withDesired: properties)
        overlay.alpha = 0.5
    }
    
}
