//
//  Default+App.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 02/05/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation
import UIKit


public extension Default {
    
    enum General {
        static let iOSMinWidth: CGFloat = 320.0
        static let StatusBarStyle: UIStatusBarStyle = .lightContent
    }
    
    
    enum Meme {
        static let IsSelected = false
        static let CloseImageButtonBackgroundColor = UIColor.clear
        
        enum Text {
            static let Top = "TOP"
            static let Bottom = "BOTTOM"
            static let StrokeColor: UIColor = UIColor.black
            static let StrokeWidth: Float = -3.0
            static let ForegroundColor: UIColor = UIColor.white
            static let Font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 64)!
            static let InputFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 24)!
            static let AdjustFontSizeToFitWidth = true
            static let MinimumFontScaleFactor: CGFloat = 0.1
            static let Alignment: NSTextAlignment = .center
        }
        
        enum Editor {
            static let Title = "Create Meme"
            static let EditingTitle = "Edit Meme"
            
            enum TextView {
                static let FadeInDuration: TimeInterval = 0.01
                static let FadeOutDuration: TimeInterval = 0.25
                static let MoveFrameDuration: TimeInterval = 0.25
            }
        }
        
        enum Download {
            static let PromptTimeoutInSeconds: Int = 2
            static func prompt(numDownloaded: Int, numOfAllDownloads: Int) -> String {
                return "Downloaded memes: \(numDownloaded) of \(numOfAllDownloads)"
            }
        }
    }

    
    enum GridViewCell {
        static let ReusableCellId = "MemeCollectionViewCell"
        static let BackgroundColor: UIColor = UIColor.clear
        static let CornerRadius: CGFloat = 4.0
        
        enum Selected {
            static let OnReuse = false
            
            enum Border {
                static let Width: CGFloat = 2.0
                static let Color: UIColor = ArtKit.primaryColor
            }
            
            enum Overlay {
                static let Color: UIColor = UIColor.white.withAlphaComponent(1.0)
                static let Alpha: CGFloat = 0.5
            }
            
        }
        
        enum Unselected {
            enum Border {
                static let Width: CGFloat = 0.0
            }
        }
        
        enum AspectRatio {
            static let TooWide: CGFloat = 2.0
            static let Square: CGFloat = 1.0
            static let TooNarrow: CGFloat = 0.5
        }
        
    }
    
    
    enum ListViewCell {
        static let ReusableCellId = "MemeTableViewCell"
    }
    
    
    enum ListView {
        static let Title = "Memes"
        static let RowHeight: CGFloat = 72.0
        static let ContentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
    }
    
    
    enum GridView {
        static let NumCellsOnSmallestSide = 2   // Say for an old iPhone in portrait mode
        static let Title = "Memes"
        
        enum BarButtonItemLabel {
            enum Select {
                static let Normal = "Select"
                static let All = "Select All"
                static let None = "Deselect All"
            }
        }
    }
    
    
    enum Segues {
        
        enum FromList: String {
            case ToEditorShow = "fromMemesListToEditorShow"
            case ToEditorModal = "fromMemesListToEditorModal"
            
            public var destinationTitle: String  {
                switch self {
                case .ToEditorShow:
                    return Default.Meme.Editor.EditingTitle
                case .ToEditorModal:
                    return Default.Meme.Editor.Title
                }
            }
        }
        
        enum FromGrid: String {
            case ToEditorShow = "fromMemesGridToEditorShow"
            case ToEditorModal = "fromMemesGridToEditorModal"
            
            public var destinationTitle: String  {
                switch self {
                case .ToEditorShow:
                    return Default.Meme.Editor.EditingTitle
                case .ToEditorModal:
                    return Default.Meme.Editor.Title
                }
            }
        }
    }
    
    
    enum Notification: String {
        case MemesModified = "MemesModified"
    }
    
}


public extension Default.Random {
    
    enum Meme {
        
        static let Image = #imageLiteral(resourceName: "640x480")
        static let Size = UIScreen.main.bounds.size
        
        enum TopText {
            enum Length {
                static let Min = 2
                static let Max = 10
            }
        }
        
        enum BottomText {
            enum Length {
                static let Min = 4
                static let Max = 15
            }
        }
        
        enum Download {
            static let Min = 80
            static let Max = 100
        }
        
    }
    
}


