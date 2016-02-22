//
//  SectionsTableViewController.swift
//  StudyRxSwift
//
//  Created by 宋宋 on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias TableSectionModel = AnimatableSectionModel<String, SectionsModel>

class SectionsTableViewController: UITableViewController {
    
    var disposeBag = DisposeBag()
    /// 保存所有的 Section
    var sections = Variable([TableSectionModel]())
    
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
        tvDataSource.configureCell = { (tv, ip, i) in
            let cell = tv.dequeueReusableCellWithIdentifier("SectionsCell") as! SectionsTableViewCell
            cell.nameLabel.text = i.value.name
            cell.ageLabel.text = String(i.value.age)
            return cell
        }
        
        sections.asObservable()
            .bindTo(tableView.rx_itemsWithDataSource(tvDataSource))
            .addDisposableTo(disposeBag)
        
        sections.value = [TableSectionModel(model: "", items: SectionsTableViewController.initialValue)]

    }

}
