//
//  NetworkManager.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/16.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    static let dataKey = "data"
    static let errorKey = "error"
    
    var site = "https://od.cdc.gov.tw/eic/Dengue_Daily_last12m.json"
    
    var dengueFeverData:[DengueFeverData] = [] {
        didSet {
            postData()
        }
    }
    
    
    func reloadData() {
        clearData()
        fetchDengueData()
    }
    
    func clearData() {
        dengueFeverData = []
    }
    
    func fetchDengueData() {
        if !dengueFeverData.isEmpty {
            postData()
            return
        }
        
        guard let url = URL(string: site) else {
            assert(false, "Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        // Setup Session
        let urlConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: urlConfig)
        
        let urlTask = urlSession.dataTask(with: urlRequest) {[unowned self] (data, response, error) in
            guard error == nil else {
                assert(false, "Error : \(error!.localizedDescription)")
                DispatchQueue.main.async {
                    NotificationPoster.postError("Error : \(error!.localizedDescription)")
                }
                
                return
            }
            
            guard let data = data else {
                assert(false, "Error : Data Not Received")
                DispatchQueue.main.async {
                    NotificationPoster.postError("Error : Unable to fetch data")
                }
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            
            do {
                
                self.dengueFeverData = try JSONDecoder().decode([DengueFeverData].self, from: data)
                
                
            } catch {
                assert(false, "Error : In Converting to JSON")
                DispatchQueue.main.async {
                    NotificationPoster.postError("Error : Failed to Convert JSON, please tell the monkey to fix this")
                }
                return
            }
            
        }
        
        urlTask.resume()
    }
    
    private init() {
        
    }
    
    private func postData() {
        NotificationCenter.default.post(name: Notification.Name.DFDidReceivedData, object: nil, userInfo: [NetworkManager.dataKey: dengueFeverData])
    }
}
