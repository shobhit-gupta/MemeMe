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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    override func viewWillLayoutSubviews() {
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
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
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
extension MemeCollectionViewController {
    
    typealias ElementType = Meme
    typealias CellType = MemeCollectionViewCell
    
    var reusableCellIdentifier: String {
        return"MemeCollectionViewCell"
    }
    
    var source: [Meme] {
        get { return _memes }
        set { _memes = newValue }
    }
    
    
    func dataItem(at indexPath: IndexPath) -> ElementType {
        return source[indexPath.item]
    }
    
    
    func configureCell(_ cell: CellType, with dataItem: ElementType) {
        cell.imageView.image = dataItem.memedImage
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? source.count : 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellIdentifier, for: indexPath) as? CellType else {
            print("1. Couldn't find UICollectionViewCell with reusable cell identifier: \(reusableCellIdentifier) or, \n2. Couldn't downcast to \(CellType.self)")
            return UICollectionViewCell()
        }
        
        // Configure the cell
        configureCell(cell, with: dataItem(at: indexPath))
        return cell
    }
    
}



