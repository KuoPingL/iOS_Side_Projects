//
//  Annotation.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/16.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation
import MapKit

class DengueCase: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    private var dengueData:DengueFeverData
    
    static let kIdentifier = "case"
    
    init(dengueData:DengueFeverData) {
        self.dengueData = dengueData
        coordinate = dengueData.coordinate
        super.init()
    }
    
    var sex: Sex {
        return dengueData.性別 ?? .不知
    }
    
//    var title: String? {
//        return dengueData.年齡層Enum.rawValue
//    }
    
    var subtitle: String? {
        return dengueData.年齡層
    }
    
    override var description: String {
        return dengueData.uniqueKey
    }
    
    var location: String {
        return dengueData.居住鄉鎮 ?? "未知鄉鎮"
    }
    
    func annotationView() -> MKAnnotationView {
        let view = MKAnnotationView(annotation: self, reuseIdentifier: DengueCase.kIdentifier)
        return view
    }
}




