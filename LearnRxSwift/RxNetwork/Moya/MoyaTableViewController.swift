//
//  MoyaTableViewController.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/21.
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
        tvDataSource.configureCell = { (_, tv, ip, i) in
            let cell = tv.dequeueReusableCellWithIdentifier("UserCell") as! UserTableViewCell
            cell.nameLabel.text = i.name
            cell.ageLabel.text = String(i.age)
            return cell
        }
        
        sections.asObservable()
            .bindTo(tableView.rx_itemsWithDataSource(tvDataSource))
            .addDisposableTo(disposeBag)
        
        UserProvider
            .request(.Users) // 请求用户s
            .mapObject(UserListModel) // 将 用户 解析到 Model
            .subscribeNext { [unowned self] userList in
                self.sections.value.append(MoyaSectionModel(model: "Users", items: userList.users))
            }
            .addDisposableTo(disposeBag)

    }

}
