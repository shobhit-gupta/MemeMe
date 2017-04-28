//
//  UIImage+Random.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 25/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    public enum RandomImageCategory: String {
        case Abstarct = "abstract"
        case Animals = "animals"
        case Business = "business"
        case Cats = "cats"
        case City = "city"
        case Food = "food"
        case Nightlife = "nightlife"
        case Fashion = "fashion"
        case People = "people"
        case Nature = "nature"
        case Sports = "sports"
        case Technics = "technics"
        case Transport = "transport"
        
        private static var categories: [RandomImageCategory] {
            return [RandomImageCategory.Abstarct, .Animals, .Business, .Cats, .City, .Food, .Nightlife, .Fashion, .People, .Nature, .Sports, .Technics, .Transport]
        }
        
        public static func random() -> RandomImageCategory {
            let idx = Int.random(lower: 0, upper: categories.count)
            return categories[idx]
        }
        
    }
    
    
    public static func random(width: CGFloat, height: CGFloat, category: RandomImageCategory? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        return random(width: Int(width), height: Int(height), category: category, completion: completion)
    }
    
    
    public static func random(width: Double, height: Double, category: RandomImageCategory? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        return random(width: Int(width), height: Int(height), category: category, completion: completion)
    }
    
    
    public static func random(width: Int? = nil, height: Int? = nil, category: RandomImageCategory? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        let _width = width ?? Int.random(lower: 10, upper: 1920)
        let _height = height ?? Int.random(lower: 10, upper: 1920)
        let _category = category ?? RandomImageCategory.random()
        
        let url = loremPixelURL(width: _width, height: _height, category: _category)
        asyncGetImage(from: url, completion: completion)
        
    }
    
    
    private static func loremPixelURL(width: Int, height: Int, category: RandomImageCategory) -> URL {
        let url = "https://lorempixel.com/\(width)/\(height)/\(category.rawValue)/"
        return URL(string: url)!
    }
    
}

