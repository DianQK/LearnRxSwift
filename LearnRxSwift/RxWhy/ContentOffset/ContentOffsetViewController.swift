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
            .rx_contentOffset
            .map { $0.y }
            .subscribeNext { [unowned self] in
                self.title = "contentOffset.x = \($0)"
            }.addDisposableTo(disposeBag)
        // ---------
        
        Observable.just([1, 2, 3, 4, 5, 6, 7])
            .bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) { (_, element, cell) in
                cell.textLabel?.text = "\(element)"
            }.addDisposableTo(disposeBag)

    }

}
