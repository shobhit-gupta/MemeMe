//
//  ArrayDataSourceController.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 24/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public protocol ArrayDataSourceController {
    associatedtype ElementType
    associatedtype CellType: UIView
    
    var source: [ElementType] { get }
    var reusableCellIdentifier: String { get }
    func configureCell(_ cell: CellType, with dataItem: ElementType)
    
}


public protocol MutableArrayDataSourceController: ArrayDataSourceController  {
    var source: [ElementType] { get set }
}
