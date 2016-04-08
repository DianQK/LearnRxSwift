//
//  ViewController.swift
//  UseDisposeBag
//
//  Created by DianQK on 16/4/8.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.rx_text
            .subscribe {
                print($0)
            }
            .addDisposableTo(DisposeBag())
//            .addDisposableTo(rx_disposeBag)
        
        button1.rx_tap
            .flatMapLatest { [unowned self] in self.showTextFieldAlert1("请输入相册名称") }
            .subscribe {
                print($0)
            }
            .addDisposableTo(rx_disposeBag)

        
        button2.rx_tap
            .flatMapLatest { [unowned self] in self.showTextFieldAlert2("请输入相册名称") }
            .subscribe {
                print($0)
            }
            .addDisposableTo(rx_disposeBag)
        
        
    }

    func showTextFieldAlert1(message: String) -> Observable<String> {
        return Observable.create { observe  in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler { textField in
                observe.onNext(textField)
            }
            
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel) { _ in
                observe.onCompleted()
            })
            
            alert.view.setNeedsLayout()
            self.presentViewController(alert, animated: true, completion: nil)
            
            return AnonymousDisposable {
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            
            }
            .flatMapLatest { (textField: UITextField) -> Observable<String> in
                return textField.rx_text.asObservable()
        }
    }
    
    func showTextFieldAlert2(message: String) -> Observable<String> {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler(nil)
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        
        alert.view.setNeedsLayout()
        self.presentViewController(alert, animated: true, completion: nil)
        
        if let textField = alert.textFields?.first {
            return textField.rx_text.asObservable()
        } else {
            return Observable.empty()
        }
    }

}
