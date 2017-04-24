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
    public var memes: [Meme]?
    
    
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
    
    fileprivate var tableViewDataSource: MutableArrayTableViewDataSource<MemeTableViewController>? = nil
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createDataSource()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        setupNavItem()
    }
    
    
    private func setupNavItem() {
        navigationItem.title = "Memes"
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
    typealias ElementType = Meme
    typealias CellType = UITableViewCell
    
    var source: [Meme] {
        get { return _memes }
        set { _memes = newValue }
    }
    
    var reusableCellIdentifier: String {
        return "MemeTableViewCell"
    }
    
    
    func configureCell(_ cell: UITableViewCell, with dataItem: Meme) {
        cell.imageView?.image = dataItem.memedImage
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(dataItem.topText)...\(dataItem.bottomText)"
        cell.setEditing(true, animated: true)
    }
    
    
    func createDataSource() {
        tableViewDataSource = MutableArrayTableViewDataSource(withController: self, for: tableView)
    }
    
}




