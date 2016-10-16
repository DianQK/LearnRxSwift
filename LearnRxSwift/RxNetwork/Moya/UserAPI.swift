//
//  UserAPI.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/2/22.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import Moya

let UserProvider = RxMoyaProvider<UserAPI>()

public enum UserAPI {
    case users
}

extension UserAPI: TargetType {
    public var baseURL: NSURL { return NSURL(string: host)! }
    public var path: String {
        switch self {
        case .users:
            return "/users"
        }
    }
    
    public var method: Moya.Method {
        return .GET
    }
    
    public var parameters: [String: AnyObject]? {
        return nil
    }
    
    public var sampleData: NSData {
        switch self {
        case .users:
            return "".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}
