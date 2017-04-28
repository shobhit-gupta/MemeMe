//
//  Meme.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 20/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    private(set) var memedImage: UIImage!
    
    
    init(topText: String, bottomText: String, originalImage: UIImage, size: CGSize) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        memedImage = generateMemedImage(of: size) ?? originalImage
    }
    
    
    private func generateMemedImage(of size: CGSize) -> UIImage? {
        // Prepare MemeView
        let memeView = MemeView(frame: CGRect(origin: CGPoint.zero, size: size))
        memeView.setProperties(topText: topText, bottomText: bottomText, image: originalImage)
        memeView.closeImageButton.isHidden = true
        
        // Render MemeView to image
        let scale = memeView.image!.size.width / memeView.imageView.frame.width
        let meme = memeView.renderToImage(atScale: scale)
        
        // Crop MemeView to appropriate size (remember MemeView is a DynamicImageView)
        let imageContentRect = memeView.imageView.frame
        let scaledRect = CGRect(x: ceil(imageContentRect.origin.x * scale),
                                y: ceil(imageContentRect.origin.y * scale),
                                width: floor(imageContentRect.width * scale),
                                height: floor(imageContentRect.height * scale))
        let croppedMeme = meme?.crop(to: scaledRect, orientation: .up) ?? meme
        
        return croppedMeme
        
    }
    
    
}


extension Meme {
    
    public static func random(completion: @escaping (Meme?) -> Void) {
        UIImage.random { (image, error) in
            if let error = error as? Error_.Network.Get.Image {
                print(error.localizedDescription)
            } else if let error = error {
                print(error.info())
            }
            
            let image = image ?? #imageLiteral(resourceName: "640x480")
            let topText = String.random(.sentence, minLength: 4, maxLength: 15)
            let bottomText = String.random(.sentence, minLength: 4, maxLength: 15)
            let meme = Meme(topText: topText, bottomText: bottomText, originalImage: image, size: UIScreen.main.bounds.size)
            completion(meme)
            
        }
    }
    
}


