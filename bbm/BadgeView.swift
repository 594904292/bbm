//
//  BadgeView.swift
//  BadgeView
//
//  Created by Shannon Wu on 1/12/16.
//  Copyright © 2016 Shannon's Dreamland. All rights reserved.
//

import UIKit

// MARK: BadgeView

@IBDesignable class BadgeView: UIView {
    @IBInspectable var fontColor: UIColor = UIColor.whiteColor() {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 11 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var value: Int = -1 {
        didSet {
            if value < 0 {
                text = nil
            } else if value == 0 {
                text = ""
                state = .Flag
            } else if value < 10 {
                text = "\(value)"
                state = .NumericRound
            } else if value < 100 {
                text = "\(value)"
                state = .NumericSquare
            } else {
                text = "99+"
                state = .NumericSquare
            }
            
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var flagSize: CGSize = CGSize(width: 7.0, height: 7.0)
    
    private var text: String? {
        didSet {
            if text == nil {
                hidden = true
            } else {
                hidden = false
            }
        }
    }
    
    private let edgeInsets = UIEdgeInsets(top: 2.0, left: 10.0, bottom: 2.0, right: 10.0)
    
    private enum State {
        case NumericRound
        case NumericSquare
        case Flag
    }
    private var state: State = .Flag
    
    private var textSize: CGSize {
        return (text ?? "" as NSString).sizeWithAttributes(textAttributes)
    }
    
    private var textAttributes: [String : AnyObject]? {
        return  [
            NSFontAttributeName: UIFont.systemFontOfSize(fontSize),
            NSForegroundColorAttributeName: fontColor
        ]
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // Set corner radius
        switch state {
        case .Flag:
            layer.cornerRadius = rect.height / 2.0
            return
        case .NumericRound:
            layer.cornerRadius = rect.height / 2.0
        case .NumericSquare:
            layer.cornerRadius = cornerRadius
        }
        clipsToBounds = true
        
        // Draw text
        let textFrame = CGRect(origin: CGPoint(x: (rect.width - textSize.width) / 2.0, y: (rect.height - textSize.height) / 2.0), size: textSize)
        (text ?? "" as NSString).drawInRect(textFrame, withAttributes: textAttributes)
    }
    
    override func intrinsicContentSize() -> CGSize {
        switch state {
        case .Flag:
            return flagSize
        case .NumericRound:
            let dimension = max(textSize.width + edgeInsets.right + edgeInsets.left, textSize.height + edgeInsets.top + edgeInsets.top + edgeInsets.bottom)
            return CGSize(width: dimension, height: dimension)
        case .NumericSquare:
            return CGSize(width: textSize.width + edgeInsets.right + edgeInsets.left, height: textSize.height + edgeInsets.top + edgeInsets.top + edgeInsets.bottom)
        }
    }
}