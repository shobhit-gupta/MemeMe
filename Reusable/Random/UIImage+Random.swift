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
    
    public enum ImageCategory: String {
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
        
        private static var all: [ImageCategory] {
            return [ImageCategory.Abstarct, .Animals, .Business, .Cats, .City, .Food, .Nightlife, .Fashion, .People, .Nature, .Sports, .Technics, .Transport]
        }
        
        public static func random() -> ImageCategory {
            let index = Int.random(lower: 0, upper: all.count)
            return all[index]
        }
        
    }
    
    
    public static func random(width: CGFloat, height: CGFloat, category: UIImage.ImageCategory? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        return random(width: Int(width), height: Int(height), category: category, completion: completion)
    }
    
    
    public static func random(width: Double, height: Double, category: UIImage.ImageCategory? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        return random(width: Int(width), height: Int(height), category: category, completion: completion)
    }
    
    
    public static func random(width: Int? = nil, height: Int? = nil, category: UIImage.ImageCategory? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        let _width = width ?? Int.random(lower: 10, upper: 1920)
        let _height = height ?? Int.random(lower: 10, upper: 1920)
        let _category = category ?? ImageCategory.random()
        
        let url = loremPixelURL(width: _width, height: _height, category: _category)
        asyncGetImage(from: url, completion: completion)
        
    }
    
    
    private static func loremPixelURL(width: Int, height: Int, category: UIImage.ImageCategory) -> URL {
        let url = "https://lorempixel.com/\(width)/\(height)/\(category.rawValue)/"
        return URL(string: url)!
    }
    
}

