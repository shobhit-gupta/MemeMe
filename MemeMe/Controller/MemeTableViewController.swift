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
        if let memes = memes {
            return memes
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
        }
    }
    
    fileprivate var tableViewDataSource: ArrayTableViewDataSource<MemeTableViewController>? = nil
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableViewDataSource()
        setupNavBar()
        navigationItem.title = "Memes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme(sender:)))
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    // MARK: - Table view data source

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MemeEditor", sender: indexPath.row)
    }
    
    
    func addMeme(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "MemeEditor", sender: sender)
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


extension MemeTableViewController: ArrayTableViewDataSourceController {
    typealias ElementType = Meme
    typealias CellType = UITableViewCell
    
    var source: [Meme] {
        return _memes
    }
    
    var reusableCellIdentifier: String {
        return "MemeTableViewCell"
    }
    
    
    func configureCell(_ cell: UITableViewCell, with dataItem: Meme) {
        cell.imageView?.image = dataItem.memedImage
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(dataItem.topText)...\(dataItem.bottomText)"
    }
    
    
    func createTableViewDataSource() {
        tableViewDataSource = ArrayTableViewDataSource(withController: self, for: tableView)
    }
    
}

