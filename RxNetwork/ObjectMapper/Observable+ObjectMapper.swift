//
//  Observable+ObjectMapper.swift
//  PalmCivet
//
//  Created by DianQK on 16/2/4.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import Moya
import ObjectMapper

/// Extension for processing Responses into Mappable objects through ObjectMapper
public extension ObservableType where E == Response {
    
    /// Maps data received from the signal into an object (on the default Background thread) which
    /// implements the Mappable protocol and returns the result back on the MainScheduler.
    /// If the conversion fails, the signal errors.
    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMap { response -> Observable<T> in
                return Observable.just(try response.mapObject())
            }
            .observeOn(MainScheduler.instance)
    }
    
    /// Maps data received from the signal into an array of objects (on the default Background thread)
    /// which implement the Mappable protocol and returns the result back on the MainScheduler
    /// If the conversion fails, the signal errors.
    public func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMap { response -> Observable<[T]> in
                return Observable.just(try response.mapArray())
            }
            .observeOn(MainScheduler.instance)
    }
}