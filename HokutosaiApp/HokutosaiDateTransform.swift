//
//  HokutosaiDateTransform.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class HokutosaiDateTransform : DateTransform {
    
    static let format = "yyyy-MM-dd HH:mm:ss Z"
    
    override func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let dateString = value as? String {
            return NSDate.dateFromString(dateString, format: HokutosaiDateTransform.format)
        }
        
        return nil
    }
    
}

extension NSDate {
    
    public static func dateFromString(dateString : String , format : String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(dateString)
    }
    
}