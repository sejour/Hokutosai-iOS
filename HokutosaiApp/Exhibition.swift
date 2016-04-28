//
//  Exhibition.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/28.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class Exhibition: Mappable, StandardTableViewCellData {
    
    var exhibitionId: UInt?
    var title: String?
    var exhibitor: String?
    var displays: String?
    var imageUrl: String?
    var assessmentAggregate: AssessedScore?
    var liked: Bool?
    var likesCount: UInt?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.exhibitionId <- map["exhibition_id"]
        self.title <- map["title"]
        self.exhibitor <- map["exhibitor"]
        self.displays <- map["displays"]
        self.imageUrl <- map["image_url"]
        self.assessmentAggregate <- map["assessment_aggregate"]
        self.liked <- map["liked"]
        self.likesCount <- map["likes_count"]
    }
    
    var dataId: UInt { return self.exhibitionId! }
    var dataImageUrl: String? { return self.imageUrl }
    var dataTitle: String? { return self.title }
    var dataOrganizer: String? { return self.exhibitor }
    var dataDescription: String? { return self.displays }
    var dataLikesCount: UInt? { return self.likesCount }
    var dataLiked: Bool? { return self.liked }
    
}