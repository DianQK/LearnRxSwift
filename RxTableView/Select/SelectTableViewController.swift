//
//  SelectTableViewController.swift
//  StudyRxSwift
//
//  Created by 宋宋 on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias SelectSectionModel = AnimatableSectionModel<String, SelectModel>

class SelectTableViewController: UITableViewController {

    var disposeBag = DisposeBag()

    var sections = Variable([SelectSectionModel]())
    
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
            .subscribeNext { [unowned self] in
                self.showUserInfo($0.row)
            }
            .addDisposableTo(disposeBag)
        
        let tvDataSource = RxTableViewSectionedReloadDataSource<SelectSectionModel>()
        tvDataSource.configureCell = { (tv, ip, i) in
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

// MARK: - showUserInfo

extension SelectTableViewController {
    func showUserInfo(index: Int) {
        let userInfo = SelectTableViewController.initialValue[index]
        let alertController = UIAlertController(title: "You selected \(userInfo.name)", message: "His age is \(userInfo.age)", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        presentViewController(alertController, animated: true, completion: nil)
    }
}
