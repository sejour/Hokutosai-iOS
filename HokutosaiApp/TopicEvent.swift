//
//  TopicEvent.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/02.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class TopicEvent: Mappable, TopicContentData {
    
    var title: String?
    var imageUrl: String?
    var eventId: UInt?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.imageUrl <- map["image_url"]
        self.eventId <- map["event_id"]
    }
    
    var dataTitle: String? { return self.title }
    var dataImageUrl: String? { return self.imageUrl }
    
}