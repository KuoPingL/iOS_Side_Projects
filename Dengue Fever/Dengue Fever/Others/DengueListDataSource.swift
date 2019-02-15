//
//  DengueListDataSource.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/18.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DengueListSources:NSObject, UITableViewDataSource {
    
    var didSelectCase:((CLLocationCoordinate2D)->())?
    
    let kCellID = "cell"
    let kHeaderID = "header"
    
    var isDataReady:((Bool)->())?
    
    lazy var refresh: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshHandler(_:)), for: .valueChanged)
        rc.tintColor = .red
        return rc
    }()
    
    weak var tableView:UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.register(UINib(nibName: "DengueListHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kHeaderID)
            tableView?.register(UITableViewCell.self, forCellReuseIdentifier: kCellID)
            tableView?.tableFooterView = UIView(frame: CGRect.zero)
            tableView?.addSubview(refresh)
        }
    }
    private var districts = [String]()
    private var descriptions = [String]()
    private var openedSections = [Bool]()
    private var selectedSection:Int = -1
    private var sex: Sex = .不知 {
        willSet {
            if sex == newValue && openedSections[selectedSection] {
                openedSections[selectedSection] = false
            } else {
                openedSections = Array(repeatElement(false, count: districts.count))
                openedSections[selectedSection] = true
            }
        }
        
        
        didSet {
            descriptions = []
            if let vm = viewModel {
                switch sex {
                case .女, .男:
                    descriptions = vm.getDengueDescriptionBasedOnSex(districts[selectedSection], sex)
                default:
                    descriptions = vm.getDengueDescription(districts[selectedSection])
                }
                tableView?.reloadData()
                tableView?.scrollToRow(at: IndexPath(row:NSNotFound, section:selectedSection), at: .top, animated: false)
            }
        }
    }
    
    var viewModel:ViewModel? {
        didSet {
            if let newVM = viewModel {
                newVM.vmListener = {[weak self] (data:[DengueFeverData], isReady:Bool) in
                    self?.districts = newVM.districtList()
                    self?.isDataReady?(isReady)
                    self?.openedSections = Array(repeatElement(false, count: self?.districts.count ?? 0))
                    DispatchQueue.main.async {
                        self?.tableView?.reloadData()
                    }
                }
                newVM.fetchVM()
            }
        }
    }
    
    func reloadData() {
        viewModel?.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return districts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedSections[section] {
            return descriptions.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: kCellID)
        }
        
        cell?.textLabel?.text = descriptions[indexPath.row]
        
        cell?.textLabel?.numberOfLines = 0
        
        return cell!
    }
    
    //MARK:- REFRESH
    
    @objc private func refreshHandler(_ sender:UIRefreshControl) {
        reloadData()
        refresh.endRefreshing()
    }
    
}

extension DengueListSources: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if openedSections[indexPath.section] {
            return 44.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("DengueListHeaderView", owner: self, options:nil)?.first as? DengueListHeaderView

        view?.sizeToFit()
        
        view?.section = section

        let location = districts[section]

        view?.locationButton.setTitle(location, for: .normal)
        view?.femaleButton.setTitle("女 (未知數)", for: .normal)
        view?.maleButton.setTitle("男 (未知數)", for: .normal)
        
        if let vm = viewModel {
            let sexes = vm.sexDistribution(location)
            view?.femaleButton.setTitle("女 (\(sexes.female))", for: .normal)
            view?.maleButton.setTitle("男 (\(sexes.male))", for: .normal)
        }


        view?.didSelectInfoType = {[unowned self] (sex:Sex, section:Int) in
            self.selectedSection = section
            self.sex = sex
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

