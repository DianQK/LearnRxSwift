//
//  AppDelegate.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        rx_sentMessage(#selector(UIViewController.viewDidAppear(_:))).subscribeNext {
            print($0)
            }.addDisposableTo(rx_disposeBag)
        
        return true
    }

}

