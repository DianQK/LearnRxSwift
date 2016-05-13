//
//  SectionsTableViewController.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias TableSectionModel = AnimatableSectionModel<String, SectionsModel>

class SectionsTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    /// 保存所有的 Section
    let sections = Variable([TableSectionModel]())
    
    static let initialValue: [SectionsModel] = [
        SectionsModel(name: "Jack", age: 18),
        SectionsModel(name: "Tim", age: 20),
        SectionsModel(name: "Andy", age: 24)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil

        let tvDataSource = RxTableViewSectionedReloadDataSource<TableSectionModel>()
        tvDataSource.configureCell = { (_, tv, ip, i) in
            let cell = tv.dequeueReusableCellWithIdentifier("SectionsCell") as! SectionsTableViewCell
            cell.nameLabel.text = i.name
            cell.ageLabel.text = String(i.age)
            return cell
        }
        
        sections.asObservable()
            .bindTo(tableView.rx_itemsWithDataSource(tvDataSource))
            .addDisposableTo(disposeBag)
        
        sections.value = [TableSectionModel(model: "", items: SectionsTableViewController.initialValue)]
        
        tableView.rx_modelSelected(SectionsModel)
            .subscribeNext {
                print($0)
            }
            .addDisposableTo(disposeBag)

    }

}
