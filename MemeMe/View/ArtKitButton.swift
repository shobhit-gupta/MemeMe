//
//  ArtKitButton.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 07/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit

@IBDesignable
class ArtKitButton: UIButton {

    enum BlendMode {
        case normal
        case overlay
    }
    
    enum ArtKitButtonKind {
        case camera(blendMode: BlendMode)
        case album(blendMode: BlendMode)
        case popular(blendMode: BlendMode)
    }
    
    var kind: ArtKitButtonKind = .camera(blendMode: .normal) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        switch kind {
        case .camera(let blendMode):
            ArtKit.drawCameraButton(frame: bounds, isPressed: blendMode == .overlay)
        case .album(let blendMode):
            ArtKit.drawAlbumButton(frame: bounds, isPressed: blendMode == .overlay)
        case .popular(let blendMode):
            ArtKit.drawPopularButton(frame: bounds, isPressed: blendMode == .overlay)
        }
    }
    

}
