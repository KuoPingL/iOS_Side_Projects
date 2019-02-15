//
//  DengueListViewController.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/18.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DengueListViewController: UIViewController, UITableViewDelegate {
    
    var didSelectCase:((CLLocationCoordinate2D)->())?
    
    private var getMapButton:UIButton = UIButton()
    private let tableDataSource = DengueListSources()
    var viewModel:ViewModel?
    
    private var rightBarItem:UIBarButtonItem = UIBarButtonItem()
    
    @IBOutlet weak private var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Setup TableView Sources (Delegate/DataSource)
        tableDataSource.tableView = tableView
        tableDataSource.isDataReady = {[weak self] (isDataReady:Bool) in
            DispatchQueue.main.async {
                self?.rightBarItem.isEnabled = isDataReady
            }
        }
        
        viewModel = ViewModel()
        
        tableDataSource.viewModel = viewModel
        
        title = "近十二個月登革熱分佈"
    }
    
    private func setupUI() {
        getMapButton = UIButton.getSideButton(self)
        getMapButton.setImage(#imageLiteral(resourceName: "mapIcon"), for: .normal)
        getMapButton.addTarget(self, action: #selector(getMap(_:)), for: .touchUpInside)
        rightBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData(_:)))
        rightBarItem.isEnabled = false
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(_:)), name: Notification.Name.ErrorOccur, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.vmListener = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - NOTIFICATION RECEIVER
    @objc private func receiveNotification(_ sender:Notification) {
        if sender.name == .ErrorOccur {
            
            var message = "Unable to fetch data, please check your connection."
            if let errorMessage = sender.userInfo?[NetworkManager.errorKey] as? String {
                message = errorMessage
            }
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    //MARK:- BUTTON ACTIONs
    @objc private func reloadData(_ sender:UIBarButtonItem) {
        rightBarItem.isEnabled = false
        tableDataSource.reloadData()
    }
    
    @objc private func getMap(_ sender:UIButton) {
        tableDataSource.tableView = nil
        tableDataSource.viewModel = nil
        dismiss(animated: true, completion: nil)
    }
}

