//
//  Button.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/18.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    static func getSideButton(_ controller:UIViewController) -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let view = controller.view!
        view.addSubview(btn)
        btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        btn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1, constant: 0).isActive = true
        btn.heightAnchor.constraint(equalTo: btn.widthAnchor, multiplier: 1.0).isActive = true
        btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        btn.layer.cornerRadius = view.frame.width * 0.1 / 2.0
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.masksToBounds = true
        btn.backgroundColor = .white
        return btn
    }
}
