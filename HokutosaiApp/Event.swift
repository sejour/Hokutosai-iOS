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

typealias EventStatus = (text: String, color: UIColor)

extension Event {
    
    var startDateTime: NSDate? {
        guard let dateString = self.dateString, let startTimeString = self.startTimeString else { return nil }
        return HokutosaiDateTransform.transformFromString("\(dateString) \(startTimeString) +0900")
    }
    
    var endDateTime: NSDate? {
        guard let dateString = self.dateString, let endTimeString = self.endTimeString else { return nil }
        return HokutosaiDateTransform.transformFromString("\(dateString) \(endTimeString) +0900")
    }
    
    private static var _startDateTimeFormatter: NSDateFormatter?
    private static var startDateTimeFormatter: NSDateFormatter {
        guard let formatter = _startDateTimeFormatter else {
            let newFormatter = NSDateFormatter()
            newFormatter.dateFormat = "yyyy/MM/dd  HH:mm"
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
    
    var status: EventStatus {
        guard let startDelta = self.startDateTime?.timeIntervalSinceNow else {
                return ("", UIColor.whiteColor())
        }
        
        if startDelta <= 0.0 {
            if let endDelta = self.endDateTime?.timeIntervalSinceNow where endDelta >= 0.0 {
                return ("開催中!!", SharedColor.EventState.red)
            }
            return ("終了しました", SharedColor.EventState.gray)
        }
        else if startDelta <= (30 * 60) {
            return ("もうすぐ! (\(Int(startDelta / 60.0))分)", SharedColor.EventState.orange)
        }
        else if startDelta <= 3600 {
            return ("あと\(Int(startDelta / 60.0))分", SharedColor.EventState.yellow)
        }
        else if startDelta <= (24 * 3600) {
            return ("あと\(Int(startDelta / 3600.0))時間", SharedColor.EventState.green)
        }
        else if startDelta <= (48 * 3600) {
            return ("明日", SharedColor.EventState.green)
        }
        
        return ("あと\(Int(startDelta / 86400.0))日", SharedColor.EventState.blue)
    }
    
}