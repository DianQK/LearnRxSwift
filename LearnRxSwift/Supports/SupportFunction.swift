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
    
    static func showInfo(_ title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    static func rx_showInfo(_ title: String, message: String? = nil) -> Observable<UIAlertActionStyle> {
        return Observable.create { observer in
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { action in
                observer.on(.next(action.style))
                })
            
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
            
            return Disposables.create()
            
        }
    }
}

extension UIApplication {
    
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
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
            case .next(let value):
                self.isNetworkActivityIndicatorVisible = value
            case .error:
                self.isNetworkActivityIndicatorVisible = false
                break
            case .completed:
                break
            }
        }
    }
}

extension UITableView {
    
    public func rx_modelItemSelected<T>(_ modelType: T.Type) -> ControlEvent<(model: T, item: IndexPath)> {
        let source: Observable<(model: T, item: IndexPath)> = rx.itemSelected.flatMap { [weak self] indexPath -> Observable<(model: T, item: IndexPath)> in
            guard let view = self else {
                return Observable.empty()
            }
            
            return Observable.just((model: try view.rx.model(indexPath), item:indexPath))
        }
        
        return ControlEvent(events: source)
    }

}
