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
    
    
    // MARK: Public variables and types
   
    
    
    // MARK: Private variables and types
    
    
    
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
            print("Camera pressed")
        case .album:
            print("Album pressed")
        case .popular:
            print("Popular pressed")
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
    
    
    func setupNavBar() {
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = ArtKit.primaryColor
            navbar.tintColor = ArtKit.secondaryColor
            // To set the status bar style to lightcontent when the navigation
            // controller displays a navigation bar.
            navbar.barStyle = .black
            title = "Create"
        }
    }
    
    
    func setupImageSourceSelector() {
        camera.kind = .camera(blendMode: .normal)
        album.kind = .album(blendMode: .normal)
        popular.kind = .popular(blendMode: .normal)
        camera.isHidden = !UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
}
