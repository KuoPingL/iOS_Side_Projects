//
//  NotificationExtension.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/16.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation
extension Notification.Name {
    static let DFDidReceivedData = Notification.Name("DFDidReceivedData")
    static let ErrorOccur = Notification.Name("ErrorOccur")
    
}


struct NotificationPoster {
    static func postError(_ message:String) {
       
        let notification = Notification(name: .ErrorOccur, object: nil, userInfo: [NetworkManager.errorKey:message])
        
        NotificationCenter.default.post(notification)
    }
}
