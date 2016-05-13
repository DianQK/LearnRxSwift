//
//  BasicTableViewController.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa

class BasicTableViewController: UITableViewController {
    
    let dataSource = Variable([BasicModel]())
    
    let disposeBag = DisposeBag()
    
    static let initialValue = [
        BasicModel(name: "Jack", age: 18),
        BasicModel(name: "Tim", age: 20),
        BasicModel(name: "Andy", age: 24)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = nil
        tableView.delegate = nil
        
        dataSource.asObservable()
//            .map { $0.sort(>) }
            .bindTo(tableView.rx_itemsWithCellIdentifier("BasicCell", cellType: BasicTableViewCell.self)) { (_, element, cell) in
                cell.nameLabel.text = element.name
                cell.ageLabel.text = String(element.age)
            }.addDisposableTo(disposeBag)
        
        dataSource.value.appendContentsOf(BasicTableViewController.initialValue)
        /**
        *  Select
        */
        tableView.rx_modelSelected(BasicModel)
            .subscribeNext { model in
                Alert.showInfo(model.name, message: "\(model.age)")
            }.addDisposableTo(disposeBag)

    }

}
