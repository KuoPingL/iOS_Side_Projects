//
//  StringExtension.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/16.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}
