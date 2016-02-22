//
//  MoyaTableViewController.swift
//  StudyRxSwift
//
//  Created by 宋宋 on 16/2/21.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias MoyaSectionModel = AnimatableSectionModel<String, UserModel>

class MoyaTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    var sections = Variable([MoyaSectionModel]())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        let tvDataSource = RxTableViewSectionedReloadDataSource<MoyaSectionModel>()
        tvDataSource.configureCell = { (tv, ip, i) in
            let cell = tv.dequeueReusableCellWithIdentifier("UserCell") as! UserTableViewCell
            cell.nameLabel.text = i.value.name
            cell.ageLabel.text = String(i.value.age)
            return cell
        }
        
        sections.asObservable()
            .bindTo(tableView.rx_itemsWithDataSource(tvDataSource))
            .addDisposableTo(disposeBag)
        
        UserProvider.request(.Users)
            .mapObject(UserListModel)
            .subscribeNext { [unowned self] userList in
                self.sections.value.append(MoyaSectionModel(model: "Users", items: userList.users))
            }
            .addDisposableTo(disposeBag)

    }

}
