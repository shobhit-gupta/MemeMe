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
        let meme = memeView.renderToImage(atScale: scale, afterScreenUpdates: true)
        
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
            
            if let error = error as? Error_.Network.Response {
                print(error.localizedDescription)
            } else if let error = error {
                print(error.info())
            }

            DispatchQueue.main.async {
                let image = image ?? Default.Random.Meme.Image
                
                let topText = String.random(.sentence,
                                            minLength: Default.Random.Meme.TopText.Length.Min,
                                            maxLength: Default.Random.Meme.TopText.Length.Max)
                
                let bottomText = String.random(.sentence,
                                               minLength: Default.Random.Meme.BottomText.Length.Min,
                                               maxLength: Default.Random.Meme.BottomText.Length.Min)
                
                let meme = Meme(topText: topText,
                                bottomText: bottomText,
                                originalImage: image,
                                size: Default.Random.Meme.Size)
                
                completion(meme)
            }
            
            
        }
    }
    
}


