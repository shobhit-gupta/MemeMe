//
//  MutableArrayTableViewDataSource.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 23/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


protocol MutableArrayTableViewDataSourceController: MutableArrayDataSourceController {
    associatedtype CellType: UITableViewCell
}


class MutableArrayTableViewDataSource<T: MutableArrayTableViewDataSourceController>: ArrayDataSource<T>, UITableViewDataSource {
    
    init(withController controller: T, for tableView: UITableView) {
        super.init(withController: controller)
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.source.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: controller.reusableCellIdentifier) as? T.CellType else {
            print("1. Couldn't find UITableViewCell with reusable cell identifier: \(controller.reusableCellIdentifier) or, \n2. Couldn't downcast to \(T.CellType.self)")
            return T.CellType()
        }
        
        controller.configureCell(cell, with: dataItem(at: indexPath))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            controller.source.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        controller.source.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
}
