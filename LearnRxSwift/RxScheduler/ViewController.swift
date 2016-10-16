//
//  ViewController.swift
//  RxScheduler
//
//  Created by DianQK on 16/3/24.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let request = URLRequest(url: URL(string: "https://github.com/fluidicon.png")!)
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLSession.shared
            .rx.data(request)
            .map { UIImage(data: $0) }
            .observeOn(.main)
            .bindTo(imageView.rx.image)
            .addDisposableTo(disposeBag)

    }

}
