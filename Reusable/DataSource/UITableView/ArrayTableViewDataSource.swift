//
//  ArrayTableViewDataSource.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 11/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


class ArrayTableViewDataSource<T: ArrayDataSourceController>: NSObject, UITableViewDataSource where T.CellType: UITableViewCell {
    
    var controller: T
    
    init(withController controller: T, for tableView: UITableView) {
        self.controller = controller
        super.init()
        tableView.dataSource = self
    }
    
    
    func dataItem(at indexPath: IndexPath) -> T.ElementType {
        return controller.source[indexPath.row]
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
    
}



