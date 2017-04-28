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
    public var memeItems: [MemeItem]?
    
    public let space: CGFloat = 0.0
    public let numCellsOnSmallerSide = 4
    
    
    // MARK: Private variables and types
    fileprivate enum State {
        case normal
        case select
    }
    
    fileprivate var currentState: State = .normal {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var _memeItems: [MemeItem] {
        get {
            if let memeItems = memeItems {
                return memeItems
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                return appDelegate.memeItems
            }
        }
        set {
            if let _ = memeItems {
                self.memeItems = newValue
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.memeItems = newValue
            }
        }
    }
    
    fileprivate var dataSource: SelectableMutableArrayCollectionViewDataSource<MemeCollectionViewController>? = nil
    
    internal var indexPathForSelectedItems = [IndexPath]()
    
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
    
    
    func selectMemes(sender: UIBarButtonItem) {
        currentState = .select
    }
    
    
    func delete(sender: UIBarButtonItem) {
        guard case .select = currentState else {
            print("Unexpected Current state: \(currentState)")
            return
        }
        dataSource?.deleteSelectedItems(in: collectionView, doesCollectionViewKnow: false)
        currentState = .normal
    }
    
    
    func selectAll(sender: UIBarButtonItem) {
        guard case .select = currentState else {
            print("Unexpected Current state: \(currentState)")
            return
        }
        
        if let title = sender.title {
            if title == "Select All" {
                dataSource?.selectAllItems(in: collectionView, doesCollectionViewKnow: false)
                sender.title = "Deselect All"
            } else if title == "Deselect All" {
                dataSource?.deSelectAllItems(in: collectionView, doesCollectionViewKnow: false)
                sender.title = "Select All"
            }
        }
    }
    
    
    func cancel(sender: UIBarButtonItem) {
        guard case .select = currentState else {
            print("Unexpected Current state: \(currentState)")
            return
        }
        
        currentState = .normal
    }

}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension MemeCollectionViewController {
    
    fileprivate func setupUI() {
        setupTitle()
        setupNavItem()
    }
    
    
    private func setupTitle() {
        if title == nil {
            title = "Memes"
        }
    }
    
    
    private func setupNavItem() {
        switch currentState {
        case .normal:
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme(sender:)))
            navigationItem.rightBarButtonItems = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectMemes(sender:)))
            
        case .select:
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(delete(sender:)))
            navigationItem.rightBarButtonItem = nil
            navigationItem.rightBarButtonItems = UIBarButtonItem.getBarButtonItems(withDictionaries: [
                [.image : #imageLiteral(resourceName: "CloseBarButton"),
                 .target : self,
                 .action : #selector(cancel(sender:))],
                
                [.title : "Select All",
                 .target : self,
                 .action : #selector(selectAll(sender:))]
                
                ])
            
            navigationItem.rightBarButtonItems?[1].possibleTitles = ["Select All", "Deselect All"]
        }
    }
    
    
    fileprivate func updateUI() {
        setupNavItem()
        switch currentState {
        case .normal:
            dataSource?.deSelectAllItems(in: collectionView, doesCollectionViewKnow: false)
            //collectionView?.deselectAll(animated: true)
            collectionView?.allowsMultipleSelection = false
        case .select:
            collectionView?.allowsMultipleSelection = true
        }
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
    
    
    override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if case .select = currentState {
            dataSource?.deselectItem(in: collectionView, at: indexPath, doesCollectionViewKnow: true)
        }
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case .normal = currentState {
            performSegue(withIdentifier: "fromMemesGridToEditorShow", sender: indexPath.item)
        } else if case .select = currentState {
            dataSource?.selectItem(in: collectionView, at: indexPath, doesCollectionViewKnow: true)
        }
    }
    
}



//******************************************************************************
//                         MARK: Collection View Data Source
//******************************************************************************
extension MemeCollectionViewController: SelectableMutableArrayCollectionViewDataSourceController {
    typealias ElementType = MemeItem
    typealias CellType = MemeCollectionViewCell
    
    var source: [MemeItem] {
        get { return _memeItems }
        set { _memeItems = newValue }
    }

    var reusableCellIdentifier: String {
        return"MemeCollectionViewCell"
    }
    
    
    func configureCell(_ cell: CellType, with dataItem: ElementType) {
        let meme = dataItem.meme
        cell.imageView.image = meme.memedImage
        cell.isSelected = dataItem.isSelected
        //cell.layer.borderWidth = 2.0
    }
    
    
    func createDataSource() {
        if let collectionView = collectionView {
            dataSource = SelectableMutableArrayCollectionViewDataSource(withController: self, for: collectionView)
        }
    }
    
}


extension MemeCollectionViewController {
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(memesModified(_:)), name: Notification.Name(rawValue: "MemesModified"), object: nil)
    }
    
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func memesModified(_ notification: Notification) {
        collectionView?.reloadData()
        indexPathForSelectedItems.forEach {
            collectionView?.selectItem(at: $0, animated: false, scrollPosition: .init(rawValue: 0))
        }
    }
    
}



