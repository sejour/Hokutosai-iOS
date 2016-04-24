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
    private static var _dateFormatter: NSDateFormatter?
    
    private static var dateFormatter: NSDateFormatter {
        guard let formatter = _dateFormatter else {
            let newFormatter = NSDateFormatter()
            newFormatter.dateFormat = format
            self._dateFormatter = newFormatter
            return newFormatter
        }
        
        return formatter
    }
    
    override func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let dateString = value as? String {
            return HokutosaiDateTransform.dateFormatter.dateFromString(dateString)
        }
        
        return nil
    }
    
}

extension NSDate {
    
    public static func dateFromString(dateString: String , format: String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(dateString)
    }
    
    public static func stringFromDate(date: NSDate, format: String) -> String {
        let formatter = NSDateFormatter()
        
        formatter.locale = NSLocale(localeIdentifier: NSLocaleLanguageCode)
        formatter.dateFormat = format
        
        return formatter.stringFromDate(date)
    }
    
}