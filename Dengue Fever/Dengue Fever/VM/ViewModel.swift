//
//  ViewModel.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/16.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation

class ViewModel {
    private var dengueFeverDatas : [DengueFeverData] = []
    
    // FIXME: Add more Models (sex distribution, age distribution)
    
    private var districtSexDistribution = [String:(male:Int, female:Int)]()
    private var districts: Set<String> = []
    private var districtDistribution = [String:[DengueFeverData]]()
    private var isReloadFinished = false
    var isDataReady: Bool {
        get {
            return isReloadFinished
        }
    }
    
    var vmListener: (([DengueFeverData], Bool)->())? = nil
    
    func reloadData() {
        isReloadFinished = false
        NetworkManager.sharedInstance.clearData()
        fetchVM()
    }
    
    func fetchVM() {
        let NC = NotificationCenter.default
        NC.removeObserver(self)
        NC.addObserver(self, selector: #selector(notificationReceived(_:)), name: Notification.Name.DFDidReceivedData, object: nil)
        NetworkManager.sharedInstance.fetchDengueData()
    }
    
    @objc private func notificationReceived(_ notification:Notification) {
        districtSexDistribution = [:]
        districtDistribution = [:]
        districts.removeAll()
        dengueFeverDatas = notification.userInfo![NetworkManager.dataKey] as! [DengueFeverData]
        dengueFeverDatas.sort {
            
            if $0.性別 == $1.性別 {
                
                return UInt8($0.年齡層Enum.rawValue) <= UInt8($1.年齡層Enum.rawValue)
            } else {
                return $0.性別 == Sex.女
            }
        }
        dengueFeverDatas.forEach {[weak self] (data) in
            let location = data.居住縣市 ?? "不知縣市"
            
            self?.districts.insert(location)
            
            if self?.districtSexDistribution[location] == nil {
                self?.districtSexDistribution[location] = (0 , 0)
            }
            
            if districtDistribution[location] == nil {
                districtDistribution[location] = [data]
            } else {
                districtDistribution[location]?.append(data)
            }
            
            let sex = data.性別 ?? .不知
            
            switch sex {
            case .女:
                self?.districtSexDistribution[location]!.female += 1
            case .男:
                self?.districtSexDistribution[location]!.male += 1
            default:
                break;
            }
            
        }
        isReloadFinished = true
        vmListener?(dengueFeverDatas, isReloadFinished)
    }
    
    func getDengueFeverData(_ at:Int) -> DengueFeverData? {
        return dengueFeverDatas[at]
    }
    
    func numberOfData() -> Int {
        return dengueFeverDatas.count
    }
    
    func numberOfData(_ at:String) -> Int {
        return districtDistribution[at]!.count
    }
    
    func districtList() -> [String] {
        return Array(districts)
    }
    
    //MARK:- CALLing Functions
    
    /// Return the number of male and female in certain district
    ///
    /// - Parameter at: District (ie 台北市)
    /// - Returns: (male:Int, female:Int)
    func sexDistribution(_ at:String) -> (male:Int, female:Int) {
        return districtSexDistribution[at] ?? (0,0)
    }
    
    
    
    /// Fetch Description(s) based on Location at certain Index for TableView
    ///
    /// - Parameters:
    ///   - forLocation: District (ie 台北市)
    ///   - at: Index
    /// - Returns: [Description:String]
    func getDengueDescription(_ forLocation:String, _ at:Int = -1) -> [String] {
        if at == -1 {            
            return districtDistribution[forLocation]!.map({
                return $0.uniqueKey
            })
        }
        
        return [districtDistribution[forLocation]![at].uniqueKey]
    }
    
    func getDengueDescriptionBasedOnSex(_ forLocation:String, _ sex:Sex = .不知) -> [String] {
        switch sex {
        case .不知:
            return districtDistribution[forLocation]!.filter({
                return $0.性別 == .不知
            }).map({
                return $0.uniqueKey
            })
        case .女:
            return districtDistribution[forLocation]!.filter({
                return $0.性別 == .女
            }).map({
                return $0.uniqueKey
            })
        case .男:
            return districtDistribution[forLocation]!.filter({
                return $0.性別 == .男
            }).map({
                return $0.uniqueKey
            })
            
        }
    }
    
}


