//
//  SupportFunction.swift
//  LearnRxSwift
//
//  Created by DianQK on 16/2/26.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

#if DEBUG
let host = "https://stg-rxswift.leanapp.cn"
#else
let host = "https://rxswift.leanapp.cn"
#endif

struct Alert {
    
    static func showInfo(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        UIApplication.topViewController()?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func rx_showInfo(title: String, message: String? = nil) -> Observable<UIAlertActionStyle> {
        return Observable.create { observer in
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .Default) { action in
                observer.on(.Next(action.style))
                })
            
            UIApplication.topViewController()?.presentViewController(alertController, animated: true, completion: nil)
            
            return NopDisposable.instance
            
        }
    }
}

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    public var rx_networkActivityIndicatorVisible: AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()
            switch event {
            case .Next(let value):
                self.networkActivityIndicatorVisible = value
            case .Error:
                self.networkActivityIndicatorVisible = false
                break
            case .Completed:
                break
            }
        }
    }
}

extension UITableView {
    
    public func rx_modelItemSelected<T>(modelType: T.Type) -> ControlEvent<(model: T, item: NSIndexPath)> {
        let source: Observable<(model: T, item: NSIndexPath)> = rx_itemSelected.flatMap { [weak self] indexPath -> Observable<(model: T, item: NSIndexPath)> in
            guard let view = self else {
                return Observable.empty()
            }
            
            return Observable.just((model: try view.rx_modelAtIndexPath(indexPath), item: indexPath))
        }
        
        return ControlEvent(events: source)
    }

}
