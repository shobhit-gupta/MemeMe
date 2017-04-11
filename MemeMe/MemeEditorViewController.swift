//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 21/02/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var camera: ArtKitButton!
    @IBOutlet weak var album: ArtKitButton!
    @IBOutlet weak var popular: ArtKitButton!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var imageSourceSelector: UIStackView!
    
    // MARK: Public variables and types
   
    
    
    // MARK: Private variables and types
    fileprivate enum State {
        case selectImage
        case selectText
        case inputText
        case memeReady
    }
    
    fileprivate var currentState: State = .selectImage {
        didSet {
            updateUI()
        }
    }
    
    
    // MARK: ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        camera.setNeedsDisplay()
        album.setNeedsDisplay()
        popular.setNeedsDisplay()
    }
    
    // MARK: Actions
    @IBAction func share(_ sender: UIBarButtonItem) {
        print("Share pressed")
    }
    
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        print("Done pressed")
    }
    
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        print("Close pressed")
    }
    

    @IBAction func showImageSource(_ sender: ArtKitButton) {
        switch sender.kind {
        case .camera:
            sender.kind = .camera(blendMode: .overlay)
            pickAnImage(from: .camera)
        case .album:
            sender.kind = .album(blendMode: .overlay)
            pickAnImage(from: .photoLibrary)
        case .popular:
            sender.kind = .popular(blendMode: .overlay)
        default:
            break
        }
        
    }
    
}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension MemeEditorViewController {
    
    // Not called when navigation controller displays a navigation bar.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func setupUI() {
        setupView()
        
        setupNavBar()
        setupImageSourceSelector()
    }
    
    
    func setupView() {
        view.backgroundColor = ArtKit.backgroundColor
    }
    
    
    func setupTitle() {
        title = "Create"
    }
    
    
    func setupNavBar() {
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = ArtKit.primaryColor
            navbar.tintColor = ArtKit.secondaryColor
            // To set the status bar style to lightcontent when the navigation
            // controller displays a navigation bar.
            navbar.barStyle = .black
        }
    }
    
    
    func setupImageSourceSelector() {
        camera.kind = .camera(blendMode: .normal)
        album.kind = .album(blendMode: .normal)
        popular.kind = .popular(blendMode: .normal)
        camera.backgroundColor = ArtKit.backgroundColor
        album.backgroundColor = ArtKit.backgroundColor
        popular.backgroundColor = ArtKit.backgroundColor
        camera.isHidden = !UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    
    
    func updateUI() {
        switch currentState {
        case .selectImage:
            imageSourceSelector.isHidden = false
            ArtKitButton.setBlendMode(of: [camera, album, popular], to: .normal)
        
        case .selectText:
            imageSourceSelector.isHidden = true
            
        case .inputText:
            imageSourceSelector.isHidden = true
            
        case .memeReady:
            imageSourceSelector.isHidden = true
        }
    }
    
    
}


//******************************************************************************
//                              MARK: Pick Image
//******************************************************************************
extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickAnImage(from sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let _ = info[UIImagePickerControllerOriginalImage] as? UIImage {
            currentState = .selectText
        } else {
            currentState = .selectImage
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        currentState = .selectImage
    }

}







