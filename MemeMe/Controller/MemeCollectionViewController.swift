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
    
    
    // MARK: Private variables and types
    fileprivate var space: CGFloat {
        // space = 1.0 for minimum width on iOS
        return round((collectionView?.bounds.width ?? 0.0) / Default.General.iOSMinWidth)
    }
    
    fileprivate var numCellsOnSmallerSide: Int {
        if let collectionView = collectionView {
            let smallerSideLength = min(collectionView.bounds.width, collectionView.bounds.height)
            let approxCellDimension = Default.General.iOSMinWidth / CGFloat(Default.GridView.NumCellsOnSmallestSide)
            return Int(round(smallerSideLength / approxCellDimension))
        }
        return Default.GridView.NumCellsOnSmallestSide
    }
    
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
    
    fileprivate var navigationPromptUpdate: DispatchWorkItem?
    
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
        
        if let identifier = Default.Segues.FromGrid(rawValue: segue.identifier ?? "") {
            switch identifier {
            case .ToEditorShow:
                guard let memeIdx = sender as? Int else {
                    let error = Error_.General.UnexpectedSegueSender(identifier: identifier.rawValue,
                                                                     sender: type(of: sender),
                                                                     expected: Int.self)
                    fatalError(error.localizedDescription)
                }
                
                guard let destination = segue.destination as? MemeEditorViewController else {
                    let error = Error_.General.UnexpectedSegueDestination(identifier: identifier.rawValue,
                                                                          destination: type(of: segue.destination),
                                                                          expected: MemeEditorViewController.self)
                    fatalError(error.localizedDescription)
                }
                
                destination.memeIdx = memeIdx
                destination.title = identifier.destinationTitle
                
            case .ToEditorModal:
                guard let _ = segue.destination as? UINavigationController else {
                    let error = Error_.General.UnexpectedSegueDestination(identifier: identifier.rawValue,
                                                                          destination: type(of: segue.destination),
                                                                          expected: UINavigationController.self)
                    fatalError(error.localizedDescription)
                }
            }
        
        } else {
            let error = Error_.General.UnexpectedSegue(identifier: segue.identifier)
            fatalError(error.localizedDescription)
        }
        
    }
    
    
    // MARK: Actions
    func addMeme(sender: UIBarButtonItem) {
        performSegue(withIdentifier: Default.Segues.FromGrid.ToEditorModal.rawValue, sender: sender)
    }
    
    
    func selectMemes(sender: UIBarButtonItem) {
        currentState = .select
    }
    
    
    func delete(sender: UIBarButtonItem) {
        guard case .select = currentState else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
            return
        }
        dataSource?.deleteSelectedItems(in: collectionView, doesCollectionViewKnow: false)
        currentState = .normal
    }
    
    
    func selectAll(sender: UIBarButtonItem) {
        guard case .select = currentState else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
            return
        }
        
        if let title = sender.title {
            if title == Default.GridView.BarButtonItemLabel.Select.All {
                dataSource?.selectAllItems(in: collectionView, doesCollectionViewKnow: false)
                sender.title = Default.GridView.BarButtonItemLabel.Select.None
                
            } else if title == Default.GridView.BarButtonItemLabel.Select.None {
                dataSource?.deSelectAllItems(in: collectionView, doesCollectionViewKnow: false)
                sender.title = Default.GridView.BarButtonItemLabel.Select.All
            }
        }
    }
    
    
    func cancel(sender: UIBarButtonItem) {
        guard case .select = currentState else {
            print(Error_.General.UnexpectedCurrentState(state: "\(currentState)").localizedDescription)
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
            title = Default.GridView.Title
        }
    }
    
    
    private func setupNavItem() {
        switch currentState {
        case .normal:
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                               target: self,
                                                               action: #selector(addMeme(sender:)))
            navigationItem.rightBarButtonItems = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Default.GridView.BarButtonItemLabel.Select.Normal,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(selectMemes(sender:)))
            
        case .select:
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                               target: self,
                                                               action: #selector(delete(sender:)))
            navigationItem.rightBarButtonItem = nil
            navigationItem.rightBarButtonItems = UIBarButtonItem.getBarButtonItems(withDictionaries: [
                [.image : #imageLiteral(resourceName: "CloseBarButton"),
                 .target : self,
                 .action : #selector(cancel(sender:))],
                
                [.title : Default.GridView.BarButtonItemLabel.Select.All,
                 .target : self,
                 .action : #selector(selectAll(sender:))]
                
                ])
            
            navigationItem.rightBarButtonItems?[1].possibleTitles = [Default.GridView.BarButtonItemLabel.Select.All,
                                                                     Default.GridView.BarButtonItemLabel.Select.None]
        }
    }
    
    
    fileprivate func updateUI() {
        setupNavItem()
        switch currentState {
        case .normal:
            dataSource?.deSelectAllItems(in: collectionView, doesCollectionViewKnow: false)
            collectionView?.allowsMultipleSelection = false
            installsStandardGestureForInteractiveMovement = true
        case .select:
            collectionView?.allowsMultipleSelection = true
            installsStandardGestureForInteractiveMovement = false
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
        let emptySpace = (numCells + 1) * space
        return (width - emptySpace) / numCells
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = cellDimension(for: collectionView)
        var width = dimension
        var height = dimension
        
        if numCellsOnSmallerSide > Default.GridView.NumCellsOnSmallestSide,
            let image = dataSource?.dataItem(at: indexPath).meme.memedImage {
            
            let aspectRatio = (image.size.width) / (image.size.height)
            if aspectRatio > Default.GridViewCell.AspectRatio.TooWide {
                height /= Default.GridViewCell.AspectRatio.TooWide
            
            } else if aspectRatio > Default.GridViewCell.AspectRatio.Square {
                height /= aspectRatio
            
            } else if aspectRatio < Default.GridViewCell.AspectRatio.TooNarrow {
                width *= 0.5
            
            } else {
                width *= aspectRatio
            }
            
        }
        
        return CGSize(width: width, height: height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2 * space
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let space = self.space
        return UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if case .select = currentState {
            dataSource?.deselectItem(in: collectionView, at: indexPath, doesCollectionViewKnow: true)
        }
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case .normal = currentState {
            performSegue(withIdentifier: Default.Segues.FromGrid.ToEditorShow.rawValue, sender: indexPath.item)
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
        return Default.GridViewCell.ReusableCellId
    }
    
    
    func configureCell(_ cell: CellType, with dataItem: ElementType) {
        let meme = dataItem.meme
        cell.imageView.image = meme.memedImage
        cell.isSelected = dataItem.isSelected
        cell.layer.cornerRadius = Default.GridViewCell.CornerRadius
    }
    
    
    func createDataSource() {
        if let collectionView = collectionView {
            dataSource = SelectableMutableArrayCollectionViewDataSource(withController: self,
                                                                        for: collectionView)
        }
    }
    
}


extension MemeCollectionViewController {
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(memesModified(_:)),
                                               name: Notification.Name(rawValue: Default.Notification.MemesModified.rawValue),
                                               object: nil)
    }
    
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func memesModified(_ notification: Notification) {
        collectionView?.reloadData()
        indexPathForSelectedItems.forEach {
            collectionView?.selectItem(at: $0,
                                       animated: false,
                                       scrollPosition: Default.CollectionView.ScrollPosition)
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            // ISSUE: memeItems.count > numMemes if the user creates new memes while the download is in progress.
            // It is a minor issue. Leave as it is for now.
            navigationItem.prompt = Default.Meme.Download.prompt(numDownloaded: appDelegate.memeItems.count,
                                                                 numOfAllDownloads: appDelegate.numMemes)
            navigationPromptUpdate?.cancel()
            let deadline = DispatchTime.now() + .seconds(Default.Meme.Download.PromptTimeoutInSeconds)
            navigationPromptUpdate = DispatchWorkItem {
                self.navigationItem.prompt = nil
            }
            if let navigationPromptUpdate = navigationPromptUpdate {
                DispatchQueue.main.asyncAfter(deadline: deadline, execute: navigationPromptUpdate)
            }
        }
    }
    
}



