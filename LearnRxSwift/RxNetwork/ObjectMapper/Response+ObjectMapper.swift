//
//  Response+ObjectMapper.swift
//  PalmCivet
//
//  Created by DianQK on 16/2/4.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import Moya
import ObjectMapper

public extension Response {
    
    /// Maps data received from the signal into an object which implements the Mappable protocol.
    /// If the conversion fails, the signal errors.
    public func mapObject<T: Mappable>() throws -> T {
        guard let json = try mapJSON() as? [String: AnyObject] else {
            throw Error.JSONMapping(self)
        }
        guard let object = Mapper<T>().map(json["data"]) else {
            throw Error.Data(self)
        }
        return object
    }
    
    /// Maps data received from the signal into an array of objects which implement the Mappable
    /// protocol.
    /// If the conversion fails, the signal errors.
    public func mapArray<T: Mappable>() throws -> [T] {
        guard let json = try mapJSON() as? [String: AnyObject] else {
            throw Error.JSONMapping(self)
        }
        guard let object = Mapper<T>().mapArray(json["data"]) else {
            throw Error.Data(self)
        }
        return object
    }
    
}