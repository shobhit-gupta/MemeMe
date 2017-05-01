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
    
    public enum RandomImageCategory: String, CanGenerateRandomValues {
        case abstarct = "abstract"
        case animals = "animals"
        case business = "business"
        case cats = "cats"
        case city = "city"
        case food = "food"
        case nightlife = "nightlife"
        case fashion = "fashion"
        case people = "people"
        case nature = "nature"
        case sports = "sports"
        case technics = "technics"
        case transport = "transport"
        
//        private static var categories: [RandomImageCategory] {
//            return arrayOfEnumCases(RandomImageCategory)
//        }
//        
//        public static func random() -> RandomImageCategory {
//            let idx = Int.random(lower: 0, upper: categories.count)
//            return categories[idx]
//        }
        
    }
    
    
    public enum Orientation: CanGenerateRandomValues {
        case portrait
        case landscape
    }
    
    
    // Note: This is just an experiment.
    // Use it for testing, not for production
    // - Shobhit Gupta
    public enum RandomImageAspectRatio: CanGenerateRandomValues {
        case vertical
        case square
        case foxMovieTone
        case earlyTV
        case standard
        case academyStandardFilm
        case a4
        case imax
        case classicStill35mm
        case creditCard
        case computer_16_10
        case golden
        case europeanWideSceen
        case hdVideoStandard
        case usWideScreen
        case univisium
        case ultraWideScreen
        case cinemaScope
        case silver
        case ultraPanavision70
        
        case any
        case outOfWhack
        
        
        public func randomSize(in orientation: Orientation) -> CGSize {
            let ratio = value()
            var size: CGSize!
            switch self {
            case .any:
                size = CGSize(width: ratio.widthFactor, height: ratio.heightFactor)
            default:
                size = randomSize(widthFactor: ratio.widthFactor, heightFactor: ratio.heightFactor)
            }
            
            let (maxVal, minVal) = size.width > size.height ? (size.width, size.height) : (size.height, size.width)
            if case .landscape = orientation {
                (size.width, size.height) = (maxVal, minVal)
            } else {
                (size.width, size.height) = (minVal, maxVal)
            }
            
            return size
        }
        
        
        public func value() -> (widthFactor: Int, heightFactor: Int) {
            return RandomImageAspectRatio.value(forAspectRatio: self)
        }
        
        
        public static func value(forAspectRatio aspectRatio: RandomImageAspectRatio) -> (widthFactor: Int, heightFactor: Int) {
            let val: (widthFactor: Int, heightFactor: Int)
            switch aspectRatio {
            case .vertical:
                val = (widthFactor: 9, heightFactor: 16)
            
            case .square:
                val = (widthFactor: 1, heightFactor: 1)
            
            case .foxMovieTone:
                val = (widthFactor: 6, heightFactor: 5)
            
            case .earlyTV:
                val = (widthFactor: 5, heightFactor: 4)
            
            case .standard:
                val = (widthFactor: 4, heightFactor: 3)
            
            case .academyStandardFilm:
                val = (widthFactor: 11, heightFactor: 8)
            
            case .a4:
                val = (widthFactor: 141, heightFactor: 100)
            
            case .imax:
                val = (widthFactor: 143, heightFactor: 100)
            
            case .classicStill35mm:
                val = (widthFactor: 3, heightFactor: 2)
            
            case .creditCard:
                val = (widthFactor: 159, heightFactor: 100)
            
            case .computer_16_10:
                val = (widthFactor: 8, heightFactor: 5)
            
            case .golden:
                val = (widthFactor: 81, heightFactor: 50)
            
            case .europeanWideSceen:
                val = (widthFactor: 5, heightFactor: 3)
            
            case .hdVideoStandard:
                val = (widthFactor: 16, heightFactor: 9)
            
            case .usWideScreen:
                val = (widthFactor: 37, heightFactor: 20)
            
            case .univisium:
                val = (widthFactor: 2, heightFactor: 1)
            
            case .ultraWideScreen:
                val = (widthFactor: 7, heightFactor: 3)
            
            case .cinemaScope:
                val = (widthFactor: 239, heightFactor: 100)
            
            case .silver:
                val = (widthFactor: 241, heightFactor: 100)
            
            case .ultraPanavision70:
                val = (widthFactor: 69, heightFactor: 25)
            
            case .any:
                let width = Int.random(lower: Default.UIImage_.Random.Width.Min, upper: Default.UIImage_.Random.Width.Max)
                let height = Int.random(lower: Default.UIImage_.Random.Height.Min, upper: Default.UIImage_.Random.Height.Max)
                val = (widthFactor: width, heightFactor: height)
            
            case .outOfWhack:
                let widthGap = Default.UIImage_.Random.Width.Max - Default.UIImage_.Random.Width.Min
                let heightGap = Default.UIImage_.Random.Height.Max - Default.UIImage_.Random.Height.Min
                let upperHeightLimitFactor = min(widthGap / 64, heightGap)
                // Multiply widthFactor's lower limit by 3 > 2.76 (ratio for ultraPanavision70) for really wide aspect ratio.
                let widthFactor = Int.random(lower: upperHeightLimitFactor * 3, upper: Default.UIImage_.Random.Width.Max / 4)
                let heightFactor = Int.random(lower: 1, upper: upperHeightLimitFactor)
                val = (widthFactor: widthFactor, heightFactor: heightFactor)
            
            }
            
            return val
        
        }
        
        
        // This method can obviously break very easily. Add guard statements later.
        // Use it as a private function for now.
        private func randomSize(widthFactor: Int, heightFactor: Int) -> CGSize {
            if widthFactor > heightFactor {
                let upperMultiple = Default.UIImage_.Random.Width.Max / widthFactor
                let lowerMultiple = Default.UIImage_.Random.Width.Min / widthFactor < 1 ? 1 : Default.UIImage_.Random.Width.Min / widthFactor
                let randomMultiple = Int.random(lower: lowerMultiple, upper: upperMultiple)
                return CGSize(width: widthFactor * randomMultiple, height: heightFactor * randomMultiple)
            } else {
                let upperMultiple = Default.UIImage_.Random.Height.Max / heightFactor
                let lowerMultiple = Default.UIImage_.Random.Height.Min / heightFactor < 1 ? 1 : Default.UIImage_.Random.Height.Min / heightFactor
                let randomMultiple = Int.random(lower: lowerMultiple, upper: upperMultiple)
                return CGSize(width: widthFactor * randomMultiple, height: heightFactor * randomMultiple)
            }
        }
    }
    
    
    public static func random(aspectRatio: RandomImageAspectRatio? = nil, orientation: Orientation? = nil, category: RandomImageCategory? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        let _aspectRatio = aspectRatio ?? RandomImageAspectRatio.random()
        let _orientation = orientation ?? Orientation.random()
        let size = _aspectRatio.randomSize(in: _orientation)
        return random(width: size.width, height: size.height, category: category, completion: completion)
    }
    
    
    public static func random(width: CGFloat, height: CGFloat, category: RandomImageCategory? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        return random(width: Int(width), height: Int(height), category: category, completion: completion)
    }
    
    
    public static func random(width: Double, height: Double, category: RandomImageCategory? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        return random(width: Int(width), height: Int(height), category: category, completion: completion)
    }
    
    
    public static func random(width: Int?, height: Int?, category: RandomImageCategory? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        let _width = width ?? Int.random(lower: Default.UIImage_.Random.Width.Min, upper: Default.UIImage_.Random.Width.Max)
        let _height = height ?? Int.random(lower: Default.UIImage_.Random.Height.Min, upper: Default.UIImage_.Random.Height.Max)
        let _category = category ?? RandomImageCategory.random()
        
        let url = loremPixelURL(width: _width, height: _height, category: _category)
        asyncGetImage(from: url, completion: completion)
        
    }
    
    
    private static func loremPixelURL(width: Int, height: Int, category: RandomImageCategory) -> URL {
        let url = "https://lorempixel.com/\(width)/\(height)/\(category.rawValue)/"
        return URL(string: url)!
    }
    
}


public extension Default.UIImage_ {
    enum Random {
        enum Width {
            static let Max: Int = 1920
            static let Min: Int = 1
        }
        
        enum Height {
            static let Max: Int = 1920
            static let Min: Int = 1
        }
    }
}
