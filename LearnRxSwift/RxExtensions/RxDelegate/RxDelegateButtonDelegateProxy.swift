//
//  RxDelegateButtonDelegateProxy.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/4/6.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa

class RxDelegateButtonDelegateProxy: DelegateProxy, RxDelegateButtonDelegate, DelegateProxyType  {
    
    static func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let rxDelegateButton = object as! RxDelegateButton
        return rxDelegateButton.delegagte
    }
    
    static func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let rxDelegateButton = object as! RxDelegateButton
        rxDelegateButton.delegagte = delegate as? RxDelegateButtonDelegate
    }
    
}
