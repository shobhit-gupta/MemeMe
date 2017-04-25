//
//  Get.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 25/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public func asyncGetData(from url: URL, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}


public func asyncGetImage(from url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
    
    asyncGetData(from: url) { (data, response, error) in
        guard let data = data, error == nil else {
            completion(nil, error)
            return
        }
        
        DispatchQueue.main.async {
            if let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, Error_.Network.Get.Image.NotAnImage(url: url))
            }
        }
        
    }
}


public extension Error_.Network {
    enum Get {
        enum Image: Error {
            case NotAnImage(url: URL)
            
            var localizedDescription: String {
                var description = String(describing: self)
                switch self {
                case .NotAnImage(let url):
                    description += "Can't construct an image from the data returned by: \(url)"
                }
                return description
            }
        }
    }
}
