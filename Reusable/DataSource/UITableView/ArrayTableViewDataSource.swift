//
//  ArrayTableViewDataSource.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 11/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


protocol ArrayTableViewDataSourceController: ArrayDataSourceController {
    associatedtype CellType: UITableViewCell
}


class ArrayTableViewDataSource<T: ArrayTableViewDataSourceController>: ArrayDataSource<T>, UITableViewDataSource {
    
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
    
}




