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
        createTableViewDataSource()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MemeEditorViewController {
            
            if let memeIdx = sender as? Int {
                destination.memeIdx = memeIdx
                destination.title = "Edit Meme"
            
            } else if let _ = sender as? UIBarButtonItem {
                destination.title = "Create Meme"
                
            }
        }
    }

    
    // MARK: Actions
    func addMeme(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "MemeEditor", sender: sender)
    }
    
}


//******************************************************************************
//                              MARK: User Interface
//******************************************************************************
extension MemeTableViewController {

    fileprivate func setupUI() {
        setupNavBar()
        setupNavItem()
    }
    
    
    private func setupNavItem() {
        navigationItem.title = "Memes"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme(sender:)))
        navigationItem.rightBarButtonItem = editButtonItem
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

}


//******************************************************************************
//                          MARK: Table View Delegate
//******************************************************************************
extension MemeTableViewController {
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MemeEditor", sender: indexPath.row)
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
    
    
    func createTableViewDataSource() {
        tableViewDataSource = MutableArrayTableViewDataSource(withController: self, for: tableView)
    }
    
}




