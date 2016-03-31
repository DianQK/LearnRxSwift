//
//  UIView+IB.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/3/26.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            if let borderColor = layer.borderColor {
                return UIColor(CGColor: borderColor)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
