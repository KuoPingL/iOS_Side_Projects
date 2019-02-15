//
//  DengueDataHeaderView.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/18.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation
import UIKit

class DengueListHeaderView: UIView {
    
    var section:Int = -1
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    
    var didSelectInfoType:((Sex, Int)->())?
    
    @IBAction func didSelect(_ sender: UIButton) {
        
        switch sender {
        case locationButton:
            didSelectInfoType?(.不知, section)
        case femaleButton:
            didSelectInfoType?(.女, section)
        default:
            didSelectInfoType?(.男, section)
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let padding:CGFloat = 5
        let path = UIBezierPath()
        let leftBottomPoint = CGPoint(x: padding, y: frame.height - padding)
        let rightBottomPoint = CGPoint(x: frame.width - 2 * padding, y: leftBottomPoint.y)
        path.move(to: leftBottomPoint)
        path.addLine(to: rightBottomPoint)
        path.close()
        
        UIColor.black.setStroke()
        path.stroke()
    }
    
    
}
