//
//  SectionsModel.swift
//  StudyRxSwift
//
//  Created by 宋宋 on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import Foundation

struct SectionsModel {
    let name: String
    let age: Int
}

extension SectionsModel: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

func ==(lhs: SectionsModel, rhs: SectionsModel) -> Bool {
    return lhs.name == rhs.name
}

extension SectionsModel: CustomStringConvertible {
    var description: String {
        return "\(name)'s age is \(age)"
    }
}
