//
//  TopicEvent.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/02.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class TopicEvent: Event, TopicContentData {
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
    }
    
    var dataTitle: String? { return self.title }
    var dataImageUrl: String? { return self.imageUrl }
    
}