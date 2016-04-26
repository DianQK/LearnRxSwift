//
//  Proposer+Rx.swift
//  LearnRxSwift
//
//  Created by 宋宋 on 16/4/25.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import Proposer
import RxSwift

//public func proposeToAccess(resource: PrivateResource, agreed successAction: ProposerAction, rejected failureAction: ProposerAction)

func rx_proposeToAccess(resource: PrivateResource) -> Observable<Bool> {
    return Observable.create { observer in
        proposeToAccess(resource,
            agreed: {
                observer.onNext(true)
                observer.onCompleted()
            }, rejected: {
                observer.onNext(false)
                observer.onCompleted()
        })
        return NopDisposable.instance
    }
}
