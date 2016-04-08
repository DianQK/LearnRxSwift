//
//  SelectTableViewController.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias SelectSectionModel = AnimatableSectionModel<String, SelectModel>

class SelectTableViewController: UITableViewController {

    let disposeBag = DisposeBag()

    let sections = Variable([SelectSectionModel]())
    
    static let initialValue: [SelectModel] = [
        SelectModel(name: "Jack", age: 18),
        SelectModel(name: "Tim", age: 20),
        SelectModel(name: "Andy", age: 24)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        tableView.rx_itemSelected
            .subscribeNext { indexPath in
                let userInfo = SelectTableViewController.initialValue[indexPath.row]
                Alert.showInfo(userInfo.name, message: "\(userInfo.age)")
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx_modelSelected(IdentifiableValue<SelectModel>)
            .subscribeNext { model in
                Alert.showInfo(model.identity.name, message: "\(model.identity.age)")
            }
            .addDisposableTo(disposeBag)
        
        let tvDataSource = RxTableViewSectionedReloadDataSource<SelectSectionModel>()
        tvDataSource.configureCell = { (_, tv, ip, i) in
            let cell = tv.dequeueReusableCellWithIdentifier("SelectCell") as! SelectTableViewCell
            cell.nameLabel.text = i.value.name
            cell.ageLabel.text = String(i.value.age)
            return cell
        }
        sections.asObservable()
            .bindTo(tableView.rx_itemsWithDataSource(tvDataSource))
            .addDisposableTo(disposeBag)
        sections.value = [SelectSectionModel(model: "", items: SelectTableViewController.initialValue)]
        
    }

}
