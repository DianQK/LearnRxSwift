//
//  AlamofireTableViewController.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/21.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import Alamofire
import RxAlamofire

typealias AlamofireSectionModel = AnimatableSectionModel<String, UserModel>

class AlamofireTableViewController: UITableViewController {

    let disposeBag = DisposeBag()
    
    let sections = Variable([AlamofireSectionModel]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        let tvDataSource = RxTableViewSectionedReloadDataSource<AlamofireSectionModel>()
        tvDataSource.configureCell = { (_, tv, ip, i) in
            let cell = tv.dequeueReusableCellWithIdentifier("UserCell") as! UserTableViewCell
            cell.nameLabel.text = i.name
            cell.ageLabel.text = String(i.age)
            return cell
        }
        
        sections.asObservable()
            .bindTo(tableView.rx_itemsWithDataSource(tvDataSource))
            .addDisposableTo(disposeBag)
        
        let manager = Manager.sharedInstance
        manager.rx_responseJSON(.GET, host + "/users")
            .mapObject(UserListModel)
            .subscribeNext { [unowned self] in
                self.sections.value.append(AlamofireSectionModel(model: "Users", items: $0.users))
            }
            .addDisposableTo(disposeBag)

    }

}
