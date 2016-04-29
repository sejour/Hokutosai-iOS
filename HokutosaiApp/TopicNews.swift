//
//  TopicNews.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/30.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class TopicNews: Mappable, TopicContentData {

    var title: String?
    var mediaUrl: String?
    var newsId: UInt?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.mediaUrl <- map["media_url"]
        self.newsId <- map["news_id"]
    }
    
    var dataTitle: String? { return self.title }
    var dataImageUrl: String? { return self.mediaUrl }
    
}