//
//  DriverLoginViewController.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/3/31.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Alamofire
import RxAlamofire

class DriverLoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: DriverLoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginTrigger = [loginButton.rx_tap, usernameTextField.rx_controlEvent(.EditingDidEndOnExit)]
            .toObservable()
            .merge()
        
        viewModel = DriverLoginViewModel(input: (
            usename: usernameTextField.rx_text.asDriver(),
            tap: loginTrigger.asDriver(onErrorJustReturn: ())))
        
        viewModel.loginEnabled.asDriver(onErrorJustReturn: false)
            .drive(loginButton.rx_enabled)
            .addDisposableTo(rx_disposeBag)
        
        viewModel.loginRequesting.asDriver(onErrorJustReturn: false)
            .drive(UIApplication.sharedApplication().rx_networkActivityIndicatorVisible)
            .addDisposableTo(rx_disposeBag)
        
        viewModel.loginResult
            .driveNext { result in
                Alert.showInfo(result.1)
            }
            .addDisposableTo(rx_disposeBag)
        
        view.rx_sentMessage(#selector(UIView.touchesBegan(_:withEvent:)))
            .subscribeNext { [unowned self] _ in
                self.usernameTextField.resignFirstResponder()
            }
            .addDisposableTo(rx_disposeBag)
        
        rx_sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .subscribeNext { [unowned self] _ in
                self.usernameTextField.becomeFirstResponder()
            }
            .addDisposableTo(rx_disposeBag)
        
    }
    
}

