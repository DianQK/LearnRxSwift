//
//  ContentOffsetViewController.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/19.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa

class ContentOffsetViewController: UITableViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        // ---------
        tableView
            .rx.contentOffset
            .map { $0.y }
            .subscribe(onNext: { [unowned self] in
                self.title = "contentOffset.x = \($0)"
            }).addDisposableTo(disposeBag)
        // ---------

        Observable.just([1, 2, 3, 4, 5, 6, 7])
            .bindTo(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, element, cell) in
                cell.textLabel?.text = "\(element)"
            }.addDisposableTo(disposeBag)

    }

}
