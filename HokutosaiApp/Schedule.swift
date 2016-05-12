//
//  Schedule.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/03.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class Schedule: Mappable {
    
    var scheduleId: Int?
    var dateString: String?
    var day: String?
    var timetable: [Event]?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.scheduleId <- map["schedule_id"]
        self.dateString <- map["date"]
        self.day <- map["day"]
        self.timetable <- map["timetable"]
    }
    
}