//
//  Storyboard.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/18.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum StoryboardName:String {
        case TableData
    }
    
    class func getStoryBoardWithName(_ name:StoryboardName) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue, bundle: nil)
    }
}
