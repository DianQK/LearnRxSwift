//
//  UserAPI.swift
//  LearnRxSwift
//
//  Created by 宋宋 on 16/2/22.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import Moya

#if DEBUG
let host = "https://stg-rxswift.leanapp.cn"
#else
let host = "https://rxswift.leanapp.cn"
#endif

let UserProvider = RxMoyaProvider<UserAPI>()

public enum UserAPI {
    case Users
}

extension UserAPI: TargetType {
    public var baseURL: NSURL { return NSURL(string: host)! }
    public var path: String {
        switch self {
        case .Users:
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
        case .Users:
            return "".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}
