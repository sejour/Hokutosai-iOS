//
//  HokutosaiDate.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/02.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation

class HokutosaiDate {
    
    static let eveDateString = "2016-05-20"
    static let firstDateString = "2016-05-21"
    static let secondDateString = "2016-05-22"
    
    static let eveDate: NSDate = HokutosaiDateTransform.transformFromString("\(eveDateString) 00:00:00 +0900")!
    static let firstDate: NSDate = HokutosaiDateTransform.transformFromString("\(firstDateString) 00:00:00 +0900")!
    static let secondDate: NSDate = HokutosaiDateTransform.transformFromString("\(secondDateString) 00:00:00 +0900")!
    
    // 北斗祭2016前夜祭を0日とした相対日を取得する
    static var days: Int {
        let delta = NSDate().timeIntervalSinceDate(eveDate)
        return Int(floor(delta / 86400.0))
    }
    
}