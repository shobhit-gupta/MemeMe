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
    
    fileprivate var tableViewDataSource: MutableArrayTableViewDataSource<MemeTableViewController>? = nil
    
    
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
        
        switch segue.identifier ?? "" {
        case "fromMemesListToEditorShow":
            guard let memeIdx = sender as? Int else {
                fatalError("Unexpected sender: \(String(describing: sender)) for segue identifier:\(String(describing: segue.identifier))")
            }
            
            guard let destination = segue.destination as? MemeEditorViewController else {
                fatalError("Unexpected destination for segue identifier:\(String(describing: segue.identifier))")
            }
            
            destination.memeIdx = memeIdx
            destination.title = "Edit Meme"
            
        case "fromMemesListToEditorModal":
            guard let _ = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination for segue identifier:\(String(describing: segue.identifier))")
            }
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        
        }
        
    }

    
    // MARK: Actions
    func addMeme(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "fromMemesListToEditorModal", sender: sender)
    }
    
}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension MemeTableViewController {

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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme(sender:)))
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
        performSegue(withIdentifier: "fromMemesListToEditorShow", sender: indexPath.row)
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
        return "MemeTableViewCell"
    }
    
    
    func configureCell(_ cell: UITableViewCell, with dataItem: MemeItem) {
        let meme = dataItem.meme
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        cell.setEditing(true, animated: true)
    }
    
    
    func createDataSource() {
        tableViewDataSource = MutableArrayTableViewDataSource(withController: self, for: tableView)
    }
    
}



extension MemeTableViewController {
    
    func sunscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(memesAdded(_:)), name: Notification.Name(rawValue: "MemesModified"), object: nil)
    }
    
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func memesAdded(_ notification: Notification) {
        tableView.reloadData()
    }
    
}




