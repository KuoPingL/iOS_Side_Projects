//
//  JSON.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/16.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation
import CoreLocation

typealias Codable = Decodable & Encodable

struct DengueFeverData: Codable{
    
    static let kTaiwanX = 120.9605, kTaiwanY = 23.6978
    
    var 發病日, 個案研判日, 通報日: String?
    var 性別: Sex?
    var 年齡層: String?
    var 年齡層Enum: Age {
        get {
            guard let aging = 年齡層 else {
                return .unknown
            }
            
            switch aging {
            case "1-4":
                return .f1t4
            case "5-9":
                return .f5t9
            case "10-14":
                return .f10t14
            case "15-19":
                return .f15t19
            case "20-24":
                return .f20t24
            case "25-29":
                return .f25t29
            case "30-34":
                return .f30t34
            case "35-39":
                return .f35t39
            case "40-44":
                return .f40t44
            case "45-49":
                return .f45t49
            case "50-54":
                return .f50t54
            case "55-59":
                return .f55t59
            case "60-64":
                return .f60t64
            case "65-69":
                return .f65t69
            case "70+":
                return .f70Up
            default:
                return .unknown
            }
        }
    }
    var 居住縣市, 居住鄉鎮, 居住村里, 居住村里代碼, 感染村里代碼, 血清型, 內政部居住縣市代碼, 內政部居住鄉鎮代碼, 內政部感染縣市代碼, 內政部感染鄉鎮代碼: String?
    var 最小統計區, 一級統計區, 二級統計區: String?
    var 感染縣市, 感染鄉鎮, 感染村里, 感染國家: String?
    var 是否境外移入: IsImmigration?
    var 最小統計區中心點X, 最小統計區中心點Y: String?
    var coordinate: CLLocationCoordinate2D {
        get {
            var x = 最小統計區中心點X?.doubleValue ?? DengueFeverData.kTaiwanX
            
            var y = 最小統計區中心點Y?.doubleValue ?? DengueFeverData.kTaiwanY
            
            if x == 0 && y == 0 {
                x = DengueFeverData.kTaiwanX
                y = DengueFeverData.kTaiwanY
            }
            
            return CLLocationCoordinate2D(latitude: y, longitude: x)
        }
    }
    var 確定病例數: String?
    var title: String {
        get {
            let sex = (性別 ?? .不知).rawValue
            let age = 年齡層Enum.rawValue
            return "\(sex)性(\(age))"
        }
    }
    var uniqueKey:String {
        get {
            let sex = (性別 ?? .不知).rawValue
            var isImmigrant = "並非"
            if 是否境外移入 ?? .否 == .是 {isImmigrant = "確定是"}
            let age = 年齡層 ?? "未知歲數"
            let location = (居住縣市 ?? "某某縣市") + (居住鄉鎮 ?? "某某鄉鎮") + (居住村里 ?? "某某村里")
            let cases = 確定病例數 ?? "未知"
            
            return "案例為\(sex)性(\(age))，\(isImmigrant)境外移入。居住在\(location)已有\(cases)確診"
        }
    }
    
}

enum Sex: String, Codable{
    case 男, 女, 不知
}

enum IsImmigration: String, Codable {
    case 是, 否
}

enum Age: Int {
    case f1t4, f5t9, f10t14, f15t19, f20t24, f25t29, f30t34, f35t39, f40t44, f45t49, f50t54, f55t59, f60t64, f65t69, f70Up, unknown
}


