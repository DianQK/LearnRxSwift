//
//  RxAnimationViewController.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/3/25.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

class RxAnimationViewController: UIViewController {
    
    @IBOutlet weak var redSquare: UIView!
    @IBOutlet weak var blueSquare: UIView!
    
    @IBOutlet weak var redSquare2: UIView!
    @IBOutlet weak var blueSquare2: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        RxAnimation
            .rx_animateWithDuration(0.6) {
                self.redSquare.transform = CGAffineTransformConcat(
                    CGAffineTransformMakeRotation(CGFloat(M_PI_2)),
                    CGAffineTransformMakeScale(1.5, 1.5)
                )
            }
            .rx_animateWithDuration(0.6) { finished in
                self.blueSquare.layer.transform = CATransform3DConcat(
                    CATransform3DMakeRotation(CGFloat(-M_PI_2), 0.0, 0.0, 1.0),
                    CATransform3DMakeScale(1.33, 1.33, 1.33)
                )
            }
            .rx_animateWithDuration(0.6) { finished in
                self.redSquare2.transform = CGAffineTransformConcat(
                    CGAffineTransformMakeScale(1.33, 1.5),
                    CGAffineTransformMakeTranslation(0.0, 50.0)
                )
                
            }
            .subscribeNext { print($0) }
            .addDisposableTo(rx_disposeBag)
        

        
    }

}
