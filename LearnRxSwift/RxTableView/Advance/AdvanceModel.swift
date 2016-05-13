//
//  AdvanceModel.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import Foundation
import RxDataSources

struct AdvanceModel {
    let name: String
    let age: Int
}

extension AdvanceModel: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

extension AdvanceModel: IdentifiableType {
    var identity: Int {
        return hashValue
    }
}

func ==(lhs: AdvanceModel, rhs: AdvanceModel) -> Bool {
    return lhs.name == rhs.name
}
