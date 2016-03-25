//
//  TScheduler.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/3/25.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift

public enum TScheduler {
    case Main
    case Serial(DispatchQueueSchedulerQOS)
    case Concurrent(DispatchQueueSchedulerQOS)
    case Operation(NSOperationQueue)
    
    
    public func scheduler() -> ImmediateSchedulerType {
        switch self {
        case .Main:
            return MainScheduler.instance
        case .Serial(let QOS):
            return SerialDispatchQueueScheduler(globalConcurrentQueueQOS: QOS)
        case .Concurrent(let QOS):
            return ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: QOS)
        case .Operation(let queue):
            return OperationQueueScheduler(operationQueue: queue)
        }
    }
}

extension ObservableType {
    
    @warn_unused_result(message="http://git.io/rxs.uo")
    public func observeOn(scheduler: TScheduler) -> RxSwift.Observable<Self.E> {
        return observeOn(scheduler.scheduler())
    }
    
}
