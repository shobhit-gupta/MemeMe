//
//  UIView+StackView.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 18/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {
    
    public func encompassInStackView(axis: UILayoutConstraintAxis, alignment: UIStackViewAlignment) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.addArrangedSubview(self)
        return stackView
    }
    
}
