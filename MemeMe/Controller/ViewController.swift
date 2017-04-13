//
//  ViewController.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 11/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    @IBOutlet weak var memeView: MemeView!
//    @IBOutlet weak var imageSize: UILabel!
//    
//    private let images = [#imageLiteral(resourceName: "Boromir"), #imageLiteral(resourceName: "10x100"), #imageLiteral(resourceName: "100x10"), #imageLiteral(resourceName: "100x100"), #imageLiteral(resourceName: "100x2000"), #imageLiteral(resourceName: "200x600"), #imageLiteral(resourceName: "200x2000"), #imageLiteral(resourceName: "480x640"), #imageLiteral(resourceName: "640x480"), #imageLiteral(resourceName: "1000x1000"), #imageLiteral(resourceName: "1000x2000"), #imageLiteral(resourceName: "2000x100"), #imageLiteral(resourceName: "2000x200"), #imageLiteral(resourceName: "2000x1000")]
//    
//    
//    @IBAction func changeImage(_ sender: Any) {
//        let randomIndex = Int(arc4random_uniform(UInt32(images.count)))
//        let image = images[randomIndex]
//        memeView.image = image
//        imageSize.text = "\(image.size.width) x \(image.size.height)"
//    }
    
    
    
    @IBOutlet weak var focussedView: FocussedInputTextView!
    
    @IBAction func animate(_ sender: Any) {
        let initialFrame = CGRect(x: view.bounds.midX - 100, y: view.bounds.midY * 1.5, width: 200, height: 75)
        let finalFrame = CGRect(x: 16, y: 32, width: view.bounds.width - 32, height: 50)
        focussedView.animate(from: initialFrame, to: finalFrame)
    }
    
    
}
