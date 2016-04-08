//
//  RxDelegateButton.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/4/6.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@objc protocol RxDelegateButtonDelegate: NSObjectProtocol {
    @objc optional func trigger()
}

class RxDelegateButton: UIButton {
    
    weak var delegagte: RxDelegateButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTarget(self, action: #selector(RxDelegateButton.buttonTap), forControlEvents: .TouchUpInside)
    }
    
    
    @objc private func buttonTap() {
        delegagte?.trigger?()
    }

}
