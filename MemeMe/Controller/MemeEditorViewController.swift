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

    // General
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // Select Image
    @IBOutlet weak var camera: ArtKitButton!
    @IBOutlet weak var album: ArtKitButton!
    @IBOutlet weak var popular: ArtKitButton!
    @IBOutlet weak var imageSourceSelector: UIStackView!
    
    // Select Text
    @IBOutlet weak var memeView: MemeView!
    
    
    // MARK: Public variables and types
   
    // Input Text
    @IBOutlet weak var focusOnTextViewStackView: UIStackView!
    
    
    // MARK: Private variables and types
    fileprivate enum State {
        case selectImage
        case selectText
        case inputText(for: UILabel, with: FocusOnTextView?)
        case memeReady
    }
    
    fileprivate var currentState: State = .selectImage {
        didSet {
            updateUI()
        }
    }
    
    
    // MARK: UIViewController Methods
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
        guard case State.memeReady = currentState else {
            print("Asked to share. Unexpected current state: \(currentState)")
            return
        }
        
        if let meme = generateMeme() {
            let activityController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
            
            if let popoverPresentationController = activityController.popoverPresentationController {
                popoverPresentationController.barButtonItem = sender
            }
            
//            activityController.completionWithItemsHandler = { action in
//                
//            }
            
            present(activityController, animated: true, completion: nil)
        }
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
    
    
    fileprivate func setupUI() {
        setupView()
        setupTitle()
        setupNavBar()
        setupImageSourceSelector()
        setupMemeView()
        setupFocusOnTextViewStackView()
    }
    
    //--------------------------------------------------------------------------
    //                                  General
    //--------------------------------------------------------------------------
    private func setupView() {
        view.backgroundColor = ArtKit.backgroundColor
    }
    
    
    private func setupTitle() {
        title = "Create"
    }
    
    
    private func setupNavBar() {
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = ArtKit.primaryColor
            navbar.tintColor = ArtKit.secondaryColor
            // To set the status bar style to lightcontent when the navigation
            // controller displays a navigation bar.
            navbar.barStyle = .black
        }
    }
    
    
    //--------------------------------------------------------------------------
    //                            State: selectImage
    //--------------------------------------------------------------------------
    private func setupImageSourceSelector() {
        camera.kind = .camera(blendMode: .normal)
        album.kind = .album(blendMode: .normal)
        popular.kind = .popular(blendMode: .normal)
        camera.backgroundColor = ArtKit.backgroundColor
        album.backgroundColor = ArtKit.backgroundColor
        popular.backgroundColor = ArtKit.backgroundColor
        camera.isHidden = !UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    //--------------------------------------------------------------------------
    //                            State: selectText
    //--------------------------------------------------------------------------
    private func setupMemeView() {
        memeView.delegate = self
    }
    
    
    fileprivate func updateMemeView(with image: UIImage) {
        memeView.image = image
    }
    
    
    //--------------------------------------------------------------------------
    //                            State: inputText
    //--------------------------------------------------------------------------
    fileprivate func setupFocusOnTextViewStackView() {
        focusOnTextViewStackView.isHidden = true
    }
    
    
    fileprivate func setupFocusOnTextView() -> FocusOnTextView {
        let focusOnTextView = FocusOnTextView()
        focusOnTextView.textView.delegate = self
        let properties = OverlayType.Properties(color: Default.Overlay.BackgroundColor,
                                                blur: OverlayType.Properties.Blur(style: Default.Overlay.BlurEffectStyle, isVibrant: true))
        focusOnTextView.overlayProperties = properties
        focusOnTextViewStackView.addArrangedSubview(focusOnTextView)
        focusOnTextViewStackView.isHidden = true
        return focusOnTextView
    }
    
    
    //--------------------------------------------------------------------------
    //                              Manage State
    //--------------------------------------------------------------------------
    fileprivate func updateUI() {
        switch currentState {
        case .selectImage:
            ArtKitButton.setBlendMode(of: [camera, album, popular], to: .normal)
            shareButton.isEnabled = false
            doneButton.isEnabled = false
            imageSourceSelector.isHidden = false
            memeView.isHidden = true
            focusOnTextViewStackView.isHidden = true
        
        case .selectText:
            shareButton.isEnabled = false
            doneButton.isEnabled = false
            imageSourceSelector.isHidden = true
            memeView.isHidden = false
            focusOnTextViewStackView.isHidden = true
            
        case let .inputText(label, focusOnTextView):
            shareButton.isEnabled = false
            doneButton.isEnabled = false
            imageSourceSelector.isHidden = true
            memeView.isHidden = false
            
            if let focusOnTextView = focusOnTextView {
                if focusOnTextViewStackView.isHidden {
                    focusOnTextViewStackView.arrangedSubviews.forEach {
                        focusOnTextViewStackView.removeArrangedSubview($0)
                    }
                    focusOnTextViewStackView.addArrangedSubview(focusOnTextView)
                    focusOnTextViewStackView.isHidden = false
                    startFocusOnTextView()
                }
                
            } else {
                currentState = .inputText(for: label, with: setupFocusOnTextView())
            }
            
        case .memeReady:
            shareButton.isEnabled = true
            doneButton.isEnabled = true
            imageSourceSelector.isHidden = true
            memeView.isHidden = false
            focusOnTextViewStackView.isHidden = true
        }
    }
    
    
}


//******************************************************************************
//                              MARK: Select Image
//******************************************************************************
extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickAnImage(from sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            updateMemeView(with: image)
            currentState = (memeView.topText != nil) && (memeView.bottomText != nil) ? .memeReady : .selectText
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



//******************************************************************************
//                              MARK: Select Text
//******************************************************************************
extension MemeEditorViewController: MemeViewDelegate {
    
    func closeImageButtonPressed() {
        memeView.image = nil
        currentState = .selectImage
    }
    
    func memeLabelTapped(sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel,
            memeView.top === label || memeView.bottom === label {
         
            currentState = .inputText(for: label, with: nil)
        
        }
    }
    
}


//******************************************************************************
//                              MARK: Input Text
//******************************************************************************
extension MemeEditorViewController: UITextViewDelegate {
    
    fileprivate func startFocusOnTextView() {
        
        guard case let State.inputText(label, focusOnTextViewOptional) = currentState,
            let focusOnTextView = focusOnTextViewOptional else {
                print("Unexpected Current state: \(currentState)")
                return
        }
        
        let initialFrame = label.superview?.convert(label.frame, to: focusOnTextView)
        focusOnTextView.fadeIn(duration: 0.01) { _ in
            focusOnTextView.start(from: initialFrame, in: 0.25) {
                focusOnTextView.textView.text = label.text
                focusOnTextView.textView.textAlignment = label.textAlignment
            }
        }
    }
    
    
    fileprivate func endFocusOnTextView() {
        
        guard case let State.inputText(label, focusOnTextViewOptional) = currentState,
            let focusOnTextView = focusOnTextViewOptional else {
                print("Unexpected Current state: \(currentState)")
                return
        }
        
        let finalFrame = label.superview?.convert(label.frame, to: focusOnTextView)
        memeView.set(text: focusOnTextView.textView.text, for: label)
        focusOnTextView.end(on: finalFrame)
        focusOnTextView.fadeOut(duration: Default.UIView_.Fade.Out.Duration) {_ in 
            self.focusOnTextViewStackView.isHidden = true
        }
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        endFocusOnTextView()
        currentState = (memeView.topText != nil) && (memeView.bottomText != nil) ? .memeReady : .selectText
    }
    
}


//******************************************************************************
//                              MARK: Meme Ready
//******************************************************************************
extension MemeEditorViewController {
    
    fileprivate func generateMeme() -> UIImage? {
        // Render view to image
        let scale = memeView.image!.size.width / memeView.imageView.frame.width
        let rectToDraw = memeView.bounds
        
        memeView.closeImageButton.isHidden = true
        defer {
            memeView.closeImageButton.isHidden = false
        }
        
        UIGraphicsBeginImageContextWithOptions(rectToDraw.size, false, scale)
        memeView.drawHierarchy(in: rectToDraw, afterScreenUpdates: true)
        var meme = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        // Crop
        let imageContentRect = memeView.imageView.frame
        let scaledRect = CGRect(x: ceil(imageContentRect.origin.x * scale),
                                y: ceil(imageContentRect.origin.y * scale),
                                width: floor(imageContentRect.width * scale),
                                height: floor(imageContentRect.height * scale))
        
        if let cgImage = meme?.cgImage?.cropping(to: scaledRect) {
            meme = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        }
        
        return meme
    }
    
}

