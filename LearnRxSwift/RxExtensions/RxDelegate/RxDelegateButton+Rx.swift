//
//  RxDelegateButton+Rx.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/4/6.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa

extension RxDelegateButton {
    
    var rx_delegate: DelegateProxy {
        return proxyForObject(RxDelegateButtonDelegateProxy.self, self)
    }
    
    var rx_trigger: ControlEvent<Void> {
        let source = rx_delegate.observe(#selector(RxDelegateButtonDelegate.trigger)).map { _ in }
        return ControlEvent(events: source)
    }
}
