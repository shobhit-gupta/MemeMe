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
    let memedImage: UIImage
    
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
            let meme = Meme(topText: topText, bottomText: bottomText, originalImage: image, memedImage: image)
            completion(meme)
            
        }
    }
    
}


