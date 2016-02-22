//
//  UserModel.swift
//  LearnRxSwift
//
//  Created by 宋宋 on 16/2/22.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import ObjectMapper

struct UserListModel {
    var users: [UserModel]!
}

struct UserModel {
    var name: String!
    var age: String!
}

extension UserListModel: Mappable {
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        users <- map["users"]
    }
}

extension UserListModel: Hashable {
    var hashValue: Int {
        return users.description.hashValue
    }
}

func ==(lhs: UserListModel, rhs: UserListModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

extension UserModel: Mappable {
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        age <- map["age"]
    }
}

extension UserModel: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

func ==(lhs: UserModel, rhs: UserModel) -> Bool {
    return lhs.name == rhs.name
}