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
    
    let request = NSURLRequest(URL: NSURL(string: "https://github.com/fluidicon.png")!)
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSURLSession.sharedSession()
            .rx_data(request)
            .map { UIImage(data: $0) }
            .observeOn(.Main)
            .bindTo(imageView.rx_image)
            .addDisposableTo(disposeBag)

    }

}