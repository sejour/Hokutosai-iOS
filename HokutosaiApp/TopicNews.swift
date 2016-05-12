//
//  TopicNews.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/30.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class TopicNews: Article, TopicContentData {

    var mediaUrl: String?
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        self.mediaUrl <- map["media_url"]
    }
    
    var dataTitle: String? { return self.title }
    var dataImageUrl: String? { return self.mediaUrl }
    
}