//
//  RxAnimation.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/3/25.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import UIKit
import RxSwift

public typealias RxAnimation = UIView

extension UIView {
    
    public class func rx_animateWithDuration(duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = [], animations: () -> Void) -> Observable<Bool> {
        return Observable.create { observer in
            UIView.animateWithDuration(duration, delay: delay, options: options, animations: animations) { finished in
                observer.onNext(finished)
                observer.onCompleted()
            }
            return NopDisposable.instance
        }
    }
    
//    public class func rx_animateWithDuration(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void) -> Observable<Bool> {
//        return Observable.create { observer in
//            UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options, animations: animations) { finished in
//                observer.onNext(finished)
//                observer.onCompleted()
//            }
//            return NopDisposable.instance
//        }
//    }
    
    
    
}

extension ObservableType where E: BooleanType {
    
    public func rx_animateWithDuration(duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = [], animations: () -> Void) -> Observable<Bool>  {
        return flatMap { finish in
            return UIView.rx_animateWithDuration(duration, delay: delay, options: options, animations: animations)
        }
    }
    
//    public func rx_animateWithDuration(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void) -> Observable<Bool> {
//        return UIView.rx_animateWithDuration(duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options, animations: animations)
//    }
}
