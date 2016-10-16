//
//  AdvanceTableViewController.swift
//  StudyRxSwift
//
//  Created by DianQK on 16/2/20.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias AdvanceSectionModel = AnimatableSectionModel<String, AdvanceModel>

class AdvanceTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    let sections = Variable([AdvanceSectionModel]())
    
    let tvDataSource = RxTableViewSectionedReloadDataSource<AdvanceSectionModel>()
    
    static let initialValue: [AdvanceModel] = [
        AdvanceModel(name: "Jack", age: 18),
        AdvanceModel(name: "Tim", age: 20),
        AdvanceModel(name: "Andy", age: 24)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        skinTableViewDataSource(tvDataSource)
        sections.asObservable()
            .bindTo(tableView.rx.items(dataSource: tvDataSource))
            .addDisposableTo(disposeBag)
        sections.value = [AdvanceSectionModel(model: "Section 1", items: AdvanceTableViewController.initialValue)]
        
        tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
    }
    
    func skinTableViewDataSource(_ dataSource: RxTableViewSectionedReloadDataSource<AdvanceSectionModel>) {
        dataSource.configureCell = { (_, tv, ip, i) in
            let cell = tv.dequeueReusableCell(withIdentifier: "AdvanceCell") as! AdvanceTableViewCell
            cell.nameLabel.text = i.name
            cell.ageLabel.text = String(i.age)
            return cell
        }
//        dataSource.titleForHeaderInSection = { [unowned dataSource] sectionIndex in
//            return dataSource.sectionAtIndex(sectionIndex).model
//        }
    }
    
}

// MARK: - TableView delegate

extension AdvanceTableViewController {
    /// 定制 Header Section Cell
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = tvDataSource.sectionAtIndex(section)

        let label = UILabel(frame: CGRect.zero)

        label.text = "  \(section.model)"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.darkGray
        label.alpha = 0.9
        
        return label
    }
    /// 定制 Header Section Cell 的高
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    /// 定制 Cell 的高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
