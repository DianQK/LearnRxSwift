//
//  SectionsModel.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionsModel {
    let name: String
    let age: Int
}

extension SectionsModel: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

extension SectionsModel: IdentifiableType {
    var identity: Int {
        return hashValue
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
