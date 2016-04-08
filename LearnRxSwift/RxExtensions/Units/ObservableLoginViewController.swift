//
//  ObservableLoginViewController.swift
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

class ObservableLoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: ObservableLoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginTrigger = [loginButton.rx_tap, usernameTextField.rx_controlEvent(.EditingDidEndOnExit)]
            .toObservable()
            .merge()
        
        viewModel = ObservableLoginViewModel(input: (
            usename: usernameTextField.rx_text.asObservable(),
            tap: loginTrigger))

        viewModel.loginEnabled.asObservable()
            .bindTo(loginButton.rx_enabled)
            .addDisposableTo(rx_disposeBag)
        
        viewModel.loginRequesting.asObservable()
            .bindTo(UIApplication.sharedApplication().rx_networkActivityIndicatorVisible)
            .addDisposableTo(rx_disposeBag)
        
        viewModel.loginResult
            .subscribe { event in
                switch event {
                case .Next(let result) where result.0:
                    Alert.showInfo(result.1)
                case .Next(let result) where !result.0:
                    Alert.showInfo(result.1)
                case .Error(let error):
                    print(error)
                default: break
                }
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
