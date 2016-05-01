//
//  Article.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/30.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class Article: Mappable {
    
    var newsId: UInt?
    var title: String?
    var datetime: NSDate?
    var relatedEvent: EventItem?
    var relatedShop: ShopItem?
    var relatedExhibition: ExhibitionItem?
    var isTopic: Bool?
    var tag: String?
    var text: String?
    var likesCount: UInt?
    var liked: Bool?
    var medias: [Media]?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.newsId <- map["news_id"]
        self.title <- map["title"]
        self.datetime <- (map["datetime"], HokutosaiDateTransform())
        self.relatedEvent <- map["related_event"]
        self.relatedShop <- map["related_shop"]
        self.relatedExhibition <- map["related_exhibition"]
        self.isTopic <- map["topic"]
        self.tag <- map["tag"]
        self.text <- map["text"]
        self.likesCount <- map["likes_count"]
        self.liked <- map["liked"]
        self.medias <- map["medias"]
    }
    
}
