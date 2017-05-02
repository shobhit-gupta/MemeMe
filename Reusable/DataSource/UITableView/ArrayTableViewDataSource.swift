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
        return section == 0 ? controller.source.count : Default.ArrayDataSource.ItemsCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: controller.reusableCellIdentifier) as? T.CellType else {
            let error = Error_.ArrayDataSource.DequeCellFailed(identifier: controller.reusableCellIdentifier, cellType: T.CellType.self)
            print(error.localizedDescription)
            return T.CellType()
        }
        
        controller.configureCell(cell, with: dataItem(at: indexPath))
        return cell
    }
    
}





