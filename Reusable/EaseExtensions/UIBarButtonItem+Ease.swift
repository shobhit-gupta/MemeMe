//
//  UIBarButtonItem+Ease.swift
//  OnTheMap
//
//  Created by Shobhit Gupta on 07/12/16.
//  Copyright © 2016 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


enum BarButtonItemKeys {
    case title
    case image
    case style
    case target
    case action
}


struct BarButtonItemData {
    
    let title: String?
    let image: UIImage?
    let style: UIBarButtonItemStyle
    let target: Any?
    let action: Selector?
    
    init(with dictionary: [BarButtonItemKeys : Any]) {
        title = dictionary[.title] as? String
        image = dictionary[.image] as? UIImage
        style = dictionary[.style] as? UIBarButtonItemStyle ?? .plain
        target = dictionary[.target]
        action = dictionary[.action] as? Selector
    }
    
}


extension UIBarButtonItem {
    
    convenience init(barButtonItemData: BarButtonItemData) {
        if let image = barButtonItemData.image {
        
            self.init(image: image,
                      style: barButtonItemData.style,
                      target: barButtonItemData.target,
                      action: barButtonItemData.action)
        
        } else {
            
            self.init(title: barButtonItemData.title,
                      style: barButtonItemData.style,
                      target: barButtonItemData.target,
                      action: barButtonItemData.action)
        
        }
    }
    
    
    class func getBarButtonItems(withBarButtonItemsData data: [BarButtonItemData]) -> [UIBarButtonItem] {
        var barButtonItems = [UIBarButtonItem]()
        for barButtonItemData in data {
            barButtonItems.append(UIBarButtonItem(barButtonItemData: barButtonItemData))
        }
        return barButtonItems
    }
    
    
    class func getBarButtonItems(withDictionaries dictionaries: [[BarButtonItemKeys : Any]]) -> [UIBarButtonItem] {
        return getBarButtonItems(withBarButtonItemsData: dictionaries.map {
            BarButtonItemData(with: $0)
        })
    }
    
}
