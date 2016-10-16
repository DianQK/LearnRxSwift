//
//  TScheduler.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/3/25.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift

public enum TScheduler {
    case main
    case serial(DispatchQueueSchedulerQOS)
    case concurrent(DispatchQueueSchedulerQOS)
    case operation(OperationQueue)
    
    
    public func scheduler() -> ImmediateSchedulerType {
        switch self {
        case .main:
            return MainScheduler.instance
        case .serial(let QOS):
            return SerialDispatchQueueScheduler(globalConcurrentQueueQOS: QOS)
        case .concurrent(let QOS):
            return ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: QOS)
        case .operation(let queue):
            return OperationQueueScheduler(operationQueue: queue)
        }
    }
}

extension ObservableType {
    
    public func observeOn(_ scheduler: TScheduler) -> RxSwift.Observable<Self.E> {
        return observeOn(scheduler.scheduler())
    }
    
}
