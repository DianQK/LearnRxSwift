//
//  RxDataSources+Extension.swift
//  LearnRxSwift
//
//  Created by 宋宋 on 16/5/13.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

extension String: IdentifiableType {
    
    public var identity: Int {
        return hashValue
    }

}
