//
//  DriverLoginViewModel.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/3/31.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

class DriverLoginViewModel {
    
    let loginEnabled = PublishSubject<Bool>()
    let loginRequesting = PublishSubject<Bool>()
    
    let loginResult: Driver<(Bool, String)>
    
    private let disposeBag = DisposeBag()
    
    init(input: (usename: Driver<String>, tap: Driver<Void>)) {
        
        input.usename
            .map { $0.characters.count > 4 }
            .drive(loginEnabled)
            .addDisposableTo(disposeBag)
        
        let loginRequest = input.tap
            .withLatestFrom(loginEnabled.asDriver(onErrorJustReturn: false)).filter { $0 }
            .withLatestFrom(input.usename)
            .map { ["username": $0] }
        
        let loginResponse = loginRequest
            .flatMapLatest { requestJSON(.POST, host + "/login", parameters: $0).asDriver(onErrorJustReturn: (NSHTTPURLResponse(), ["message": "2000", "data": "网络错误"])) }
        
        [loginRequest.map { _ in true }, loginResponse.map { _ in false }]
            .toObservable()
            .merge()
            .bindTo(loginRequesting)
            .addDisposableTo(disposeBag)
        
        loginResult = loginResponse.map { _, json in
            let json = json as! [String: String]
            if json["message"] == "0000" {
                return (true, json["data"]!)
            } else if json["message"] == "1000" {
                return (false, json["data"]!)
            } else if json["message"] == "2000" {
                return (false, json["data"]!)
            } else  {
                return (false, "未知错误")
            }
        }
        
    }
    
}