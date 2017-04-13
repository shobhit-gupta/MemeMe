//
//  MemeView.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 11/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit
import PureLayout


@objc
protocol MemeViewDelegate: class {
    func closeImageButtonPressed()
}


@IBDesignable
class MemeView: DynamicImageView {
    
    // MARK: Public variables and types
    @IBOutlet public var delegate: MemeViewDelegate? { didSet { resetTargetActionForCloseImageButton() } }
    @IBInspectable public var topText: String? { didSet { resetLabelsText() } }
    @IBInspectable public var bottomText: String? { didSet { resetLabelsText() } }
    
    
    // MARK: Private variables and types
    fileprivate let augmentedStackView = UIStackView(frame: CGRect.zero)
    fileprivate let top = UILabel(frame: CGRect.zero)
    fileprivate let bottom = UILabel(frame: CGRect.zero)
    fileprivate let closeImageButton = ArtKitButton(frame: CGRect.zero)
    private var shouldSetupConstraints = true
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        setupView()
    }
    
    
    // MARK: View Methods & Constraints
    override func updateConstraints() {
        if shouldSetupConstraints {
            addConstraintsForAugmentedStackView()
            addConstraintsForLabels()
        }
        super.updateConstraints()
        shouldSetupConstraints = false
    }
    
    
    private func addConstraintsForAugmentedStackView() {
        augmentedStackView.autoPinEdge(.top, to: .top, of: imageView)
        augmentedStackView.autoPinEdge(.bottom, to: .bottom, of: imageView)
        augmentedStackView.autoPinEdge(.leading, to: .leading, of: imageView)
        augmentedStackView.autoPinEdge(.trailing, to: .trailing, of: imageView)
    }
    
    
    private func addConstraintsForLabels() {
        top.autoMatch(.width, to: .width, of: augmentedStackView)
        bottom.autoMatch(.width, to: .width, of: augmentedStackView)
    }
    
    
}


//******************************************************************************
//                              MARK: MemeView Setup
//******************************************************************************
extension MemeView {
    
    fileprivate func setupView() {
        setupLabels()
        setupcloseImageButton()
        setupAugmentedStackView()
    }
    
    
    fileprivate func setupLabels() {
        setupLabel(top)
        setupLabel(bottom)
        resetLabelsText()
    }
    
    
    fileprivate func setupLabel(_ label: UILabel) {
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
    }
    
    
    fileprivate func resetLabelsText() {
        resetLabel(top, withText: topText ?? "TOP")
        resetLabel(bottom, withText: bottomText ?? "BOTTOM")
    }
    
    
    fileprivate func resetLabel(_ label: UILabel, withText text: String) {
        label.text = text
    }
    
    
    fileprivate func setupAugmentedStackView() {
        augmentedStackView.axis = .vertical
        augmentedStackView.alignment = .center
        augmentedStackView.distribution = .fillEqually
        
        let closeImageButtonStackView = UIStackView()
        closeImageButtonStackView.axis = .horizontal
        closeImageButtonStackView.alignment = .center
        closeImageButtonStackView.addArrangedSubview(closeImageButton)
        
        augmentedStackView.addArrangedSubview(top)
        augmentedStackView.addArrangedSubview(closeImageButtonStackView)
        augmentedStackView.addArrangedSubview(bottom)
        
        addSubview(augmentedStackView)
    }
    
    
    fileprivate func setupcloseImageButton() {
        closeImageButton.kind = .closeImage
        resetTargetActionForCloseImageButton()
    }
    
    
    fileprivate func resetTargetActionForCloseImageButton() {
        if let delegate = delegate {
            closeImageButton.addTarget(delegate, action: #selector(MemeViewDelegate.closeImageButtonPressed), for: .touchUpInside)
        }
    }
    
}
