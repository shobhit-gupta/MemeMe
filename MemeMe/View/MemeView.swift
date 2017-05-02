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
    func memeLabelTapped(sender: UILabel)
}


@IBDesignable
class MemeView: DynamicImageView {
    
    // MARK: Public variables and types
    @IBOutlet public var delegate: MemeViewDelegate? { didSet { setupDelegate() } }
    @IBInspectable public var topText: String? { didSet { resetLabelsText() } }
    @IBInspectable public var bottomText: String? { didSet { resetLabelsText() } }
    
    public var isReady: Bool {
        return (topText != nil) && (bottomText != nil) && (image != nil)
    }

    public let top = UILabel(frame: CGRect.zero)
    public let bottom = UILabel(frame: CGRect.zero)
    public let closeImageButton = ArtKitButton(frame: CGRect.zero)
    
    
    // MARK: Private variables and types
    fileprivate let augmentedStackView = UIStackView(frame: CGRect.zero)
    fileprivate var topStackView: UIStackView?
    fileprivate var bottomStackView: UIStackView?
    
    public var textAttributes: [String : Any] {
        var attributes = [String : Any]()
        attributes[NSStrokeColorAttributeName] = Default.Meme.Text.StrokeColor
        attributes[NSStrokeWidthAttributeName] = Default.Meme.Text.StrokeWidth
        attributes[NSForegroundColorAttributeName] = Default.Meme.Text.ForegroundColor
        attributes[NSFontAttributeName] = Default.Meme.Text.Font
        return attributes
    }
    
    private var shouldSetupConstraints = true
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    // MARK: UIView Methods & Constraints
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
    
    
    public func set(text: String?, for label: UILabel) {
        if label === top {
            topText = text
        } else if label === bottom {
            bottomText = text
        }
    }
    
    
    public func gettext(for label: UILabel) -> String? {
        if label === top {
            return topText
        } else if label === bottom {
            return bottomText
        }
        return nil
    }
    
}


//******************************************************************************
//                              MARK: Setup
//******************************************************************************
extension MemeView {
    
    fileprivate func setupView() {
        setupLabels()
        setupcloseImageButton()
        setupAugmentedStackView()
        setupDelegate()
    }
    
    
    fileprivate func setupLabels() {
        setupLabel(top)
        setupLabel(bottom)
        resetLabelsText()
    }
    
    
    fileprivate func setupLabel(_ label: UILabel) {
        //label.textColor = UIColor.white
        label.textAlignment = Default.Meme.Text.Alignment
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = Default.Meme.Text.AdjustFontSizeToFitWidth
        label.minimumScaleFactor = Default.Meme.Text.MinimumFontScaleFactor
    }
    
    
    fileprivate func resetLabelsText() {
        resetLabel(top, withText: topText ?? Default.Meme.Text.Top)
        resetLabel(bottom, withText: bottomText ?? Default.Meme.Text.Bottom)
    }
    
    
    fileprivate func resetLabel(_ label: UILabel, withText text: String) {
        label.attributedText = NSAttributedString(string: text, attributes: textAttributes)
    }
    
    
    fileprivate func setupAugmentedStackView() {
        augmentedStackView.axis = .vertical
        augmentedStackView.alignment = .center
        augmentedStackView.distribution = .fillEqually
        
        topStackView = top.encompassInStackView(axis: .horizontal, alignment: .top).encompassInStackView(axis: .horizontal, alignment: .fill)
        let closeImageButtonStackView = closeImageButton.encompassInStackView(axis: .horizontal, alignment: .center)
        bottomStackView = bottom.encompassInStackView(axis: .horizontal, alignment: .bottom).encompassInStackView(axis: .horizontal, alignment: .fill)
        
        [topStackView!, closeImageButtonStackView, bottomStackView!].forEach() { augmentedStackView.addArrangedSubview($0) }
        addSubview(augmentedStackView)
        
    }
    
    
    fileprivate func setupcloseImageButton() {
        closeImageButton.kind = .closeImage
        closeImageButton.backgroundColor = Default.Meme.CloseImageButtonBackgroundColor
    }
    
    
    fileprivate func setupDelegate() {
        if let delegate = delegate,
            let topStackView = topStackView,
            let bottomStackView = bottomStackView  {
            
            for stackView in [topStackView, bottomStackView] {
                stackView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped(sender:)))
                stackView.addGestureRecognizer(tap)
            }
            closeImageButton.addTarget(delegate, action: #selector(MemeViewDelegate.closeImageButtonPressed), for: .touchUpInside)
            
        }
    }
    
    
    @objc fileprivate func stackViewTapped(sender: UITapGestureRecognizer) {
        if let stackView = sender.view as? UIStackView {
            if stackView === topStackView {
                delegate?.memeLabelTapped(sender: top)
            } else if stackView === bottomStackView {
                delegate?.memeLabelTapped(sender: bottom)
            }
        }
    }
}


extension MemeView {
    
    public func setProperties(topText: String, bottomText: String, image: UIImage) {
        self.image = image
        set(text: topText, for: top)
        set(text: bottomText, for: bottom)
    }
    
}
