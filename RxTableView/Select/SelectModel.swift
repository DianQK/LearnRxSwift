//
//  SelectModel.swift
//  StudyRxSwift
//
//  Created by 宋宋 on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import Foundation

struct SelectModel {
    let name: String
    let age: Int
}

extension SelectModel: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

func ==(lhs: SelectModel, rhs: SelectModel) -> Bool {
    return lhs.name == rhs.name
}
