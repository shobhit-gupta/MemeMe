//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 24/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit


class MemeCollectionViewController: UICollectionViewController {

    // MARK: Public variables and types
    public var memes: [Meme]?
    
    public let space: CGFloat = 0.0
    public let numCellsOnSmallerSide = 4
    
    
    // MARK: Private variables and types
    fileprivate var _memes: [Meme] {
        get {
            if let memes = memes {
                return memes
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                return appDelegate.memes
            }
        }
        set {
            if let _ = memes {
                self.memes = newValue
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.memes = newValue
            }
        }
    }
    
    fileprivate var collectionViewDataSource: ArrayCollectionViewDataSource<MemeCollectionViewController>? = nil
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createDataSource()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToNotifications()
        collectionView?.reloadData()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromNotification()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "fromMemesGridToEditorShow":
            guard let memeIdx = sender as? Int else {
                fatalError("Unexpected sender: \(String(describing: sender)) for segue identifier:\(String(describing: segue.identifier))")
            }
            
            guard let destination = segue.destination as? MemeEditorViewController else {
                fatalError("Unexpected destination for segue identifier:\(String(describing: segue.identifier))")
            }
            
            destination.memeIdx = memeIdx
            destination.title = "Edit Meme"
            
        case "fromMemesGridToEditorModal":
            guard let _ = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination for segue identifier:\(String(describing: segue.identifier))")
            }
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
        
    }
    
    
    // MARK: Actions
    func addMeme(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "fromMemesGridToEditorModal", sender: sender)
    }

}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension MemeCollectionViewController {
    
    fileprivate func setupUI() {
        setupNavItem()
    }
    
    
    private func setupNavItem() {
        navigationItem.title = "Memes"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme(sender:)))
    }
    
}


//******************************************************************************
//                          MARK: Collection View Delegate
//******************************************************************************
extension MemeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    private func numberOfCellsInRow(for collectionView: UICollectionView) -> Int {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return width < height ? numCellsOnSmallerSide : Int(CGFloat(numCellsOnSmallerSide) * width / height)
    }
    
    
    private func cellDimension(for collectionView: UICollectionView) -> CGFloat {
        let width = collectionView.frame.width
        let numCells = CGFloat(numberOfCellsInRow(for: collectionView))
        let emptySpace = (numCells - 1) * space
        return (width - emptySpace) / numCells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = cellDimension(for: collectionView)
        return CGSize(width: dimension, height: dimension)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "fromMemesGridToEditorShow", sender: indexPath.item)
    }
    
}



//******************************************************************************
//                         MARK: Collection View Data Source
//******************************************************************************
extension MemeCollectionViewController: ArrayCollectionViewDataSourceController {
    typealias ElementType = Meme
    typealias CellType = MemeCollectionViewCell
    
    var source: [Meme] {
        get { return _memes }
        set { _memes = newValue }
    }

    var reusableCellIdentifier: String {
        return"MemeCollectionViewCell"
    }
    
    
    func configureCell(_ cell: CellType, with dataItem: ElementType) {
        cell.imageView.image = dataItem.memedImage
    }
    
    
    func createDataSource() {
        if let collectionView = collectionView {
            collectionViewDataSource = ArrayCollectionViewDataSource(withController: self, for: collectionView)
        }
    }
    
}


extension MemeCollectionViewController {
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(memesAdded(_:)), name: Notification.Name(rawValue: "GotNewMemes"), object: nil)
    }
    
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func memesAdded(_ notification: Notification) {
        collectionView?.reloadData()
    }
    
}



