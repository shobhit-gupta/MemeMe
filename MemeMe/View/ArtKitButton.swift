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
        case closeImage
    }
    
    var kind: ArtKitButtonKind = .camera(blendMode: .normal) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var bounds: CGRect {
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
        case .closeImage:
            ArtKit.drawCloseImage(frame: bounds)
        }
    }
    
    
    class func setBlendMode(of buttons: [ArtKitButton], to blendMode: BlendMode) {
        for button in buttons {
            if case .camera = button.kind {
                button.kind = .camera(blendMode: blendMode)
            } else if case .album = button.kind {
                button.kind = .album(blendMode: blendMode)
            } else if case .popular = button.kind {
                button.kind = .popular(blendMode: blendMode)
            }
        }
    }
    

}
