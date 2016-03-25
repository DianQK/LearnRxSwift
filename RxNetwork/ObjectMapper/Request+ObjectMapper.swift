//
//  Request+ObjectMapper.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/2/22.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import ObjectMapper
import Alamofire

public enum AlamofireError: ErrorType {
    case ImageMapping(NSHTTPURLResponse)
    case JSONMapping(NSHTTPURLResponse)
    case StringMapping(NSHTTPURLResponse)
    case StatusCode(NSHTTPURLResponse)
    case Data(NSHTTPURLResponse)
    case Underlying(ErrorType)
}

public extension ObservableType where E == (NSHTTPURLResponse, AnyObject) {
    
    /// Maps data received from the signal into an object (on the default Background thread) which
    /// implements the Mappable protocol and returns the result back on the MainScheduler.
    /// If the conversion fails, the signal errors.
    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMap { response -> Observable<T> in
                guard let object = Mapper<T>().map(response.1["data"]) else {
                    throw AlamofireError.JSONMapping(response.0)
                }
                return Observable.just(object)
            }
            .observeOn(MainScheduler.instance)
    }
    
    /// Maps data received from the signal into an array of objects (on the default Background thread)
    /// which implement the Mappable protocol and returns the result back on the MainScheduler
    /// If the conversion fails, the signal errors.
    public func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMap { response -> Observable<[T]> in
                guard let object = Mapper<T>().mapArray(response.1["data"]) else {
                    throw AlamofireError.JSONMapping(response.0)
                }
                return Observable.just(object)
            }
            .observeOn(MainScheduler.instance)
    }
}