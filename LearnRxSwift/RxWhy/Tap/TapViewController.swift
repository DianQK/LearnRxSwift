//
//  TapViewController.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/19.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa

class TapViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.rx_tap
            .subscribeNext {
                print("Tap")
            }.addDisposableTo(disposeBag)
        
    }

}
