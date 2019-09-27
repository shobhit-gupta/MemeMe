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


public class ArrayDataSource<T: ArrayDataSourceController>: NSObject {
    
    var controller: T
    
    public init(withController controller: T) {
        self.controller = controller
        super.init()
    }
    
    
    public func dataItem(at indexPath: IndexPath) -> T.ElementType {
        if T.CellType.self is UITableViewCell.Type {
            return controller.source[indexPath.row]
        } else {
            return controller.source[indexPath.item]
        }
    }
    
}


public extension Default {
    enum ArrayDataSource {
        static let ItemsCount = 0
    }
}

public extension Error_ {
    
    enum ArrayDataSource:Error {
        case DequeCellFailed(identifier: String, cellType: UIView.Type)
        
        var localizedDescription: String {
            var description = String(describing: self)
            switch self {
            case let .DequeCellFailed(identifier, cellType):
                description += "Failed to deque cell with reuse id: \(identifier) as \(cellType))"
            }
            
            return description
        }
    }
    
}

