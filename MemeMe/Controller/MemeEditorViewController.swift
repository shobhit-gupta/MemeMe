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
    
    // Input Text
    @IBOutlet weak var focusOnTextViewStackView: UIStackView!
    
    
    // MARK: Public variables and types
    public var memeIdx: Int? {
        get { return _memeIdx }
        set {
            guard _memeIdx == nil else { return }
            _memeIdx = newValue
        }
    }
   
    
    // MARK: Private variables and types
    fileprivate enum State: Equatable {
        case selectImage
        case selectText
        case inputText(for: UILabel, with: FocusOnTextView?)
        case memeReady
        
        // Used when guarding for multiple enum cases at once where the enum has
        // associated values (like this one) and hence doesn't conform to the
        // Equatable protcol by default.
        // See "Select Text" methods, for example: closeImageButtonPressed
        // Modified from: http://stackoverflow.com/a/35212378/471960
        private func isEqual(to state: State) -> Bool {
            switch self {
            case .selectImage:
                if case .selectImage = state { return true }
            case .selectText:
                if case .selectText = state { return true }
            case let .inputText(label1, focusOnTextView1):
                if case let .inputText(label2, focusOnTextView2) = state, label1 == label2, focusOnTextView1 == focusOnTextView2 { return true }
            case .memeReady:
                if case .memeReady = state { return true }
            }
            return false
        }
        
        static func ==(lhs: State, rhs: State) -> Bool {
            return lhs.isEqual(to: rhs)
        }
    }
    
    fileprivate var currentState: State = .selectImage {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var _memeIdx: Int?
    
    
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
    
}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension MemeEditorViewController {
    
    // Not called when navigation controller displays a navigation bar.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Default.General.StatusBarStyle
    }
    
    
    fileprivate func setupUI() {
        setupView()
        setupTitleIfNeeded()
        setupImageSourceSelector()
        setupMemeView()
        setupFocusOnTextViewStackView()
        setupOldMemeIfNeeded()
    }
    
    //--------------------------------------------------------------------------
    //                                  General
    //--------------------------------------------------------------------------
    private func setupView() {
        view.backgroundColor = ArtKit.backgroundColor
    }
    
    
    private func setupTitleIfNeeded() {
        if title == nil {
            title = Default.Meme.Editor.Title
        }
    }
    
    
    //--------------------------------------------------------------------------
    //                            State: selectImage
    //--------------------------------------------------------------------------
    private func setupImageSourceSelector() {
        camera.kind = .camera
        album.kind = .album
        popular.kind = .popular
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
    
    
    private func setupOldMemeIfNeeded() {
        if let memeIdx = memeIdx,
            let memeItems = (UIApplication.shared.delegate as? AppDelegate)?.memeItems,
            memeItems.indices.contains(memeIdx) {
            
            let memeToLoad = memeItems[memeIdx].meme
            memeView.setProperties(topText: memeToLoad.topText, bottomText: memeToLoad.bottomText, image: memeToLoad.originalImage)
            currentState = .memeReady
            memeView.layoutIfNeeded()
        }
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
        style(focusOnTextView)
        focusOnTextViewStackView.addArrangedSubview(focusOnTextView)
        focusOnTextViewStackView.isHidden = true
        return focusOnTextView
    }
    
    
    private func style(_ focusOnTextView: FocusOnTextView) {
        var textAttributes = memeView.textAttributes
        textAttributes[NSFontAttributeName] = Default.Meme.Text.InputFont
        focusOnTextView.textView.typingAttributes = textAttributes
        
    }
    
    //--------------------------------------------------------------------------
    //                              Manage State
    //--------------------------------------------------------------------------
    fileprivate func updateUI() {
        switch currentState {
        case .selectImage:
            [camera, album, popular].forEach {
                $0?.isSelected = false
                $0?.isEnabled = true
            }
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
//                              MARK: General
//******************************************************************************
extension MemeEditorViewController {
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        guard case State.memeReady = currentState else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
            return
        }
        
        if let meme = generateMeme() {
            let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
            
            if let popoverPresentationController = activityController.popoverPresentationController {
                popoverPresentationController.barButtonItem = sender
            }
            
            activityController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
                if completed {
                    self.save(meme: meme)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            present(activityController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if let meme = generateMeme() {
            save(meme: meme)
        }
        dismiss()
    }
    
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss()
    }
    
    
    private func dismiss() {
        // Modified from: 
        // https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/ImplementEditAndDeleteBehavior.html
        let isPresentingInCreateMemeMode = presentingViewController is UINavigationController || presentingViewController is UITabBarController
        if isPresentingInCreateMemeMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
    }
    
}


//******************************************************************************
//                              MARK: Select Image
//******************************************************************************
extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func showImageSource(_ sender: ArtKitButton) {
        [camera, album, popular].forEach { $0?.isEnabled = false }
        switch sender.kind {
        case .camera:
            pickAnImage(from: .camera)
        case .album:
            pickAnImage(from: .photoLibrary)
        case .popular:
            // TODO: Add popular memes
            break
        default:
            break
        }
        
    }
    
    
    func pickAnImage(from sourceType: UIImagePickerControllerSourceType) {
        guard case .selectImage = currentState else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard case .selectImage = currentState else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
            return
        }
        
        let nextState: State
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            updateMemeView(with: image)
            nextState = memeView.isReady ? .memeReady : .selectText
        } else {
            nextState = .selectImage
        }
        
        picker.dismiss(animated: true)
        self.currentState = nextState
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        guard case .selectImage = currentState else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
            return
        }
        picker.dismiss(animated: true)
        self.currentState = .selectImage
    }

}


//******************************************************************************
//                              MARK: Select Text
//******************************************************************************
extension MemeEditorViewController: MemeViewDelegate {
    
    func closeImageButtonPressed() {
        guard [.selectText, .memeReady].contains(currentState) else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
            return
        }
        
        memeView.image = nil
        currentState = .selectImage
    }
    
    
    func memeLabelTapped(sender: UILabel) {
        guard [.selectText, .memeReady].contains(currentState) else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
            return
        }
        
        if memeView.top === sender || memeView.bottom === sender {
            currentState = .inputText(for: sender, with: nil)
        }
    }
    
}


//******************************************************************************
//                              MARK: Input Text
//******************************************************************************
extension MemeEditorViewController: UITextViewDelegate {
    
    fileprivate func startFocusOnTextView() {
        guard case let .inputText(label, focusOnTextViewOptional) = currentState,
            let focusOnTextView = focusOnTextViewOptional else {
                print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
                return
        }
        
        let initialFrame = label.superview?.convert(label.frame, to: focusOnTextView)
        focusOnTextView.fadeIn(duration: Default.Meme.Editor.TextView.FadeInDuration) { _ in
            focusOnTextView.start(from: initialFrame, in: Default.Meme.Editor.TextView.MoveFrameDuration) {
                focusOnTextView.textView.text = self.memeView.gettext(for: label)
                focusOnTextView.textView.textAlignment = label.textAlignment
            }
        }
    }
    
    
    fileprivate func endFocusOnTextView() {
        guard case let .inputText(label, focusOnTextViewOptional) = currentState,
            let focusOnTextView = focusOnTextViewOptional else {
                print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
                return
        }
        
        let finalFrame = label.superview?.convert(label.frame, to: focusOnTextView)
        memeView.set(text: focusOnTextView.textView.text, for: label)
        focusOnTextView.end(on: finalFrame)
        focusOnTextView.fadeOut(duration: Default.Meme.Editor.TextView.FadeOutDuration) { _ in
            self.focusOnTextViewStackView.isHidden = true
            self.currentState = self.memeView.isReady ? .memeReady : .selectText
        }
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        endFocusOnTextView()
    }
    
}


//******************************************************************************
//                              MARK: Meme Ready
//******************************************************************************
extension MemeEditorViewController {
    
    fileprivate func save(meme: Meme) {
        let memeItem = MemeItem(with: meme)
        _ = memeItem.save(byReplacing: _memeIdx)
    }
    
    
    fileprivate func generateMeme() -> Meme? {
        guard case .memeReady = currentState else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
            return nil
        }
        
        var meme: Meme? = nil
        if let topText = memeView.topText,
            let bottomText = memeView.bottomText,
            let originalImage = memeView.image {
            
            meme = Meme(topText: topText, bottomText: bottomText, originalImage: originalImage, size: memeView.bounds.size)
            
        }
        
        return meme
    }
    
}

