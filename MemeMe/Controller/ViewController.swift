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
    
    
    
    @IBOutlet weak var memeView: MemeView!
    @IBOutlet weak var focussedStackView: UIStackView!
    let focussedView = FocusOnTextView()
    
    
    override func viewDidLoad() {
        focussedView.alpha = 0.0
        focussedStackView.insertArrangedSubview(focussedView, at: 0)
    }
    
    @IBAction func start(_ sender: Any) {
        //print("Start pressed")
        
        if let initialFrame = memeView.bottom.superview?.convert(memeView.bottom.frame, to: focussedView) {
            focussedView.textView.delegate = self
            focussedView.textView.text = memeView.bottom.text
            focussedView.textView.textAlignment = memeView.bottom.textAlignment
            focussedView.fadeIn(duration: 0.01, delay: 0.0) { _ in
                self.focussedView.start(from: initialFrame, completion: nil)
            }
        }
    }
    
    
    @IBAction func end(_ sender: Any) {
        //print("End pressed")
        if let finalFrame = memeView.bottom.superview?.convert(memeView.bottom.frame, to: focussedView) {
            memeView.bottom.text = focussedView.textView.text
            focussedView.end(on: finalFrame)
            focussedView.fadeOut()
        }
    }
    
}


extension ViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let finalFrame = memeView.bottom.superview?.convert(memeView.bottom.frame, to: focussedView) {
            memeView.bottom.text = focussedView.textView.text
            focussedView.end(on: finalFrame)
            focussedView.fadeOut()
        }
    }
}
