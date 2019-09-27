//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 21/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit


class MemeTableViewController: UITableViewController {

    // MARK: Public variables and types
    public var memeItems: [MemeItem]?
    
    
    // MARK: Private variables and types
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
    
    fileprivate var dataSource: MutableArrayTableViewDataSource<MemeTableViewController>? = nil
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createDataSource()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sunscribeToNotifications()
        tableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromNotification()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let identifier = Default.Segues.FromList(rawValue: segue.identifier ?? "") {
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
        performSegue(withIdentifier: Default.Segues.FromList.ToEditorModal.rawValue, sender: sender)
    }
    
}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension MemeTableViewController {

    fileprivate func setupUI() {
        setupTableView()
        setupTitle()
        setupNavItem()
    }
    
    
    private func setupTableView() {
        tableView.rowHeight = Default.ListView.RowHeight
        tableView.contentInset = Default.ListView.ContentInset
    }
    
    
    private func setupTitle() {
        if title == nil {
            title = Default.ListView.Title
        }
    }
    
    
    private func setupNavItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                           target: self,
                                                           action: #selector(addMeme(sender:)))
        navigationItem.rightBarButtonItem = editButtonItem
    }

}


//******************************************************************************
//                          MARK: Table View Delegate
//******************************************************************************
extension MemeTableViewController {
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Default.Segues.FromList.ToEditorShow.rawValue, sender: indexPath.row)
    }
    
    
}


//******************************************************************************
//                         MARK: Table View Data Source
//******************************************************************************
extension MemeTableViewController: MutableArrayTableViewDataSourceController {
    typealias ElementType = MemeItem
    typealias CellType = UITableViewCell
    
    var source: [MemeItem] {
        get { return _memeItems }
        set { _memeItems = newValue }
    }
    
    var reusableCellIdentifier: String {
        return Default.ListViewCell.ReusableCellId
    }
    
    
    func configureCell(_ cell: UITableViewCell, with dataItem: MemeItem) {
        let meme = dataItem.meme
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        cell.setEditing(true, animated: true)
    }
    
    
    func createDataSource() {
        dataSource = MutableArrayTableViewDataSource(withController: self, for: tableView)
    }
    
}



extension MemeTableViewController {
    
    func sunscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(memesModified(_:)),
                                               name: Notification.Name(rawValue: Default.Notification.MemesModified.rawValue),
                                               object: nil)
    }
    
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func memesModified(_ notification: Notification) {
        tableView.reloadData()
    }
    
}




