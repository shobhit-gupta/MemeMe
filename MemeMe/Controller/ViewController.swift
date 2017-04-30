////
////  ViewController.swift
////  MemeMe
////
////  Created by Shobhit Gupta on 11/04/17.
////  Copyright © 2017 Shobhit Gupta. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController {
//
////    @IBOutlet weak var memeView: MemeView!
////    @IBOutlet weak var imageSize: UILabel!
////    
////    private let images = [#imageLiteral(resourceName: "Boromir"), #imageLiteral(resourceName: "10x100"), #imageLiteral(resourceName: "100x10"), #imageLiteral(resourceName: "100x100"), #imageLiteral(resourceName: "100x2000"), #imageLiteral(resourceName: "200x600"), #imageLiteral(resourceName: "200x2000"), #imageLiteral(resourceName: "480x640"), #imageLiteral(resourceName: "640x480"), #imageLiteral(resourceName: "1000x1000"), #imageLiteral(resourceName: "1000x2000"), #imageLiteral(resourceName: "2000x100"), #imageLiteral(resourceName: "2000x200"), #imageLiteral(resourceName: "2000x1000")]
////    
////    
////    @IBAction func changeImage(_ sender: Any) {
////        let randomIndex = Int(arc4random_uniform(UInt32(images.count)))
////        let image = images[randomIndex]
////        memeView.image = image
////        imageSize.text = "\(image.size.width) x \(image.size.height)"
////    }
//    
//    
//    
//    @IBOutlet weak var memeView: MemeView!
//    @IBOutlet weak var focussedStackView: UIStackView!
//    let focussedView = FocusOnTextView()
//    fileprivate var currentLabel: UILabel?
//    
//    override func viewDidLoad() {
//        memeView.delegate = self
//        focussedStackView.insertArrangedSubview(focussedView, at: 0)
//        focussedStackView.isHidden = true
//        setup()
//    }
//    
//    
//    fileprivate func setup() {
//        focussedView.textView.delegate = self
//        let properties = OverlayType.Properties(color: Default.Overlay.BackgroundColor,
//                                                blur: OverlayType.Properties.Blur(style: Default.Overlay.BlurEffectStyle, isVibrant: true))
//        self.focussedView.overlayProperties = properties
//        
//    }
//    
//    fileprivate func start() {
//        if let currentLabel = currentLabel,
//            let initialFrame = currentLabel.superview?.convert(currentLabel.frame, to: focussedView) {
//            focussedStackView.isHidden = false
//            focussedView.fadeIn(duration: 0.01, delay: 0.0) { _ in
//                self.focussedView.start(from: initialFrame, in: 0.25) {
//                    self.focussedView.textView.text = currentLabel.text
//                    self.focussedView.textView.textAlignment = currentLabel.textAlignment
//                }
//                //self.focussedView.start(from: initialFrame, completion: nil)
//            }
//        }
//    }
//    
//    
//    fileprivate func end() {
//        if let currentLabel = currentLabel,
//            let finalFrame = currentLabel.superview?.convert(currentLabel.frame, to: focussedView) {
//            
//            currentLabel.text = focussedView.textView.text
//            focussedView.textView.text = nil
//            focussedView.end(on: finalFrame)
//            focussedView.fadeOut(duration: Default.UIView_.Fade.Out.Duration) { _ in
//                self.focussedStackView.isHidden = true
//            }
//        }
//    }
//    
//}
//
//
//extension ViewController: UITextViewDelegate {
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        end()
//    }
//}
//
//
//extension ViewController: MemeViewDelegate {
//    
//    func closeImageButtonPressed() {
//        print("Close Pressed")
//    }
//    
//    func memeLabelTapped(sender: UITapGestureRecognizer) {
//        if memeView.top === sender.view {
//            currentLabel = memeView.top
//            
//        } else if memeView.bottom === sender.view {
//            currentLabel = memeView.bottom
//        }
//        start()
//    }
//}
