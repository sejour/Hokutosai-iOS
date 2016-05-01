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
    var date: String?
    var startTime: String?
    var endTime: String?
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
        self.date <- map["date"]
        self.startTime <- map["start_time"]
        self.endTime <- map["end_time"]
        self.place <- map["place"]
        self.performer <- map["performer"]
        self.detail <- map["detail"]
        self.imageUrl <- map["image_url"]
        self.likesCount <- map["likes_count"]
        self.liked <- map["liked"]
        self.featured <- map["featured"]
    }
    
    var startDateTime: NSDate? {
        return HokutosaiDateTransform.transformFromString("\(self.date) \(self.startTime) +0900")
    }
    
    var endDateTime: NSDate? {
        return HokutosaiDateTransform.transformFromString("\(self.date) \(self.endTime) +0900")
    }
    
}