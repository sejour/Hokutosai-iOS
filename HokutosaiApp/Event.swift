//
//  Event.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/02.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class Event: Mappable {
    
    var eventId: UInt?
    var title: String?
    var dateString: String?
    var startTimeString: String?
    var endTimeString: String?
    var place: Place?
    var performer: String?
    var detail: String?
    var imageUrl: String?
    var likesCount: UInt?
    var liked: Bool?
    var featured: Bool?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.eventId <- map["event_id"]
        self.title <- map["title"]
        self.dateString <- map["date"]
        self.startTimeString <- map["start_time"]
        self.endTimeString <- map["end_time"]
        self.place <- map["place"]
        self.performer <- map["performer"]
        self.detail <- map["detail"]
        self.imageUrl <- map["image_url"]
        self.likesCount <- map["likes_count"]
        self.liked <- map["liked"]
        self.featured <- map["featured"]
    }
    
}

extension Event {
    
    var startDateTime: NSDate? {
        return HokutosaiDateTransform.transformFromString("\(self.dateString) \(self.startTimeString) +0900")
    }
    
    var endDateTime: NSDate? {
        return HokutosaiDateTransform.transformFromString("\(self.dateString) \(self.endTimeString) +0900")
    }
    
    private static var _startDateTimeFormatter: NSDateFormatter?
    private static var startDateTimeFormatter: NSDateFormatter {
        guard let formatter = _startDateTimeFormatter else {
            let newFormatter = NSDateFormatter()
            newFormatter.dateFormat = "MM/dd HH:mm"
            self._startDateTimeFormatter = newFormatter
            return newFormatter
        }
        
        return formatter
    }
    
    private static var _endTimeFormatter: NSDateFormatter?
    private static var endTimeFormatter: NSDateFormatter {
        guard let formatter = _endTimeFormatter else {
            let newFormatter = NSDateFormatter()
            newFormatter.dateFormat = "HH:mm"
            self._endTimeFormatter = newFormatter
            return newFormatter
        }
        
        return formatter
    }
    
    var holdDateTimeString: String? {
        if let startDateTime = self.startDateTime, let endDateTime = self.endDateTime {
            let startDateTimeString = Event.startDateTimeFormatter.stringFromDate(startDateTime)
            let endTimeString = Event.endTimeFormatter.stringFromDate(endDateTime)
            return "\(startDateTimeString) - \(endTimeString)"
        }
        
        return nil
    }
    
}