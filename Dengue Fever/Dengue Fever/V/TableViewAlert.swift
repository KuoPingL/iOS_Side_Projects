//
//  TableViewAlert.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/17.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation
import UIKit

class DengueTableViewAlert: NSObject, UITableViewDataSource {
    
    let controller = UIViewController()
    var tableView:UITableView = UITableView()
    let kTableID = "cell"
    var data:[String] = []
    
    func createAlert(_ with:[DengueCase]) -> UIAlertController {
        
        let maleCount = with.filter {[weak self] (dengueCase) -> Bool in
            self?.data.append(dengueCase.description)
            return dengueCase.sex == .男
            }.count
        
        let femaleCount = with.count - maleCount
        
        let title = "共有" +
            (maleCount > 0 ? "\(maleCount)男":"") +
            (femaleCount > 0 ? "\(femaleCount)女":"")
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
        
        
        let attributes = [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .headline), NSAttributedStringKey.foregroundColor:UIColor.lightGray]
        let attributedStr = NSAttributedString(string: title, attributes: attributes)
        
        alert.setValue(attributedStr, forKey: "attributedTitle")
        
        var minHeight:CGFloat = 50.0
        
        if data.count > 3 {
            minHeight = 46.0 * 3.5
        }
        
        setupController()
        
        alert.setValue(controller, forKey: "contentViewController")
        
        alert.preferredContentSize = CGSize(width: alert.view.frame.width, height: minHeight)
        
        return alert
    }
    
    private func setupController() {
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kTableID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        controller.view.addSubview(tableView)
        controller.view.bringSubview(toFront: tableView)
        controller.view.isUserInteractionEnabled = true
        tableView.isUserInteractionEnabled = true
        
        tableView.leftAnchor.constraint(equalTo: controller.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: controller.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: controller.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kTableID)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: kTableID)
        }
        cell?.backgroundColor = .clear
        cell?.textLabel?.text = data[indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.textColor = .lightGray
        return cell!
    }
}

