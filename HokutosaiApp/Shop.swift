//
//  Shop.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class Shop: StandardContentsData {
    
    var shopId: UInt?
    var name: String?
    var tenant: String?
    var sales: String?
    var imageUrl: String?
    var assessmentAggregate: AssessedScore?
    var liked: Bool?
    var likesCount: UInt?
    var introduction: String?
    var place: Place?
    var menus: [MenuItem]?
    var myAssessment: Assessment?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.introduction <- map["introduction"]
        self.place <- map["place"]
        self.menus <- map["menu"]
        self.shopId <- map["shop_id"]
        self.name <- map["name"]
        self.tenant <- map["tenant"]
        self.sales <- map["sales"]
        self.imageUrl <- map["image_url"]
        self.assessmentAggregate <- map["assessment_aggregate"]
        self.liked <- map["liked"]
        self.likesCount <- map["likes_count"]
        self.myAssessment <- map["my_assessment"]
    }
    
    var dataId: UInt { return self.shopId! }
    var dataImageUrl: String? { return self.imageUrl }
    var dataTitle: String? { return self.name }
    var dataOrganizer: String? { return self.tenant }
    var dataDescription: String? { return self.sales }
    var dataLikesCount: UInt? {
        get { return self.likesCount }
        set { self.likesCount = newValue }
    }
    var dataLiked: Bool? {
        get { return self.liked }
        set { self.liked = newValue }
    }
    var dataIntroduction: String? { return self.introduction }
    var dataPlace: Place? { return self.place }
    var dataAssessmentAggregate: AssessedScore? {
        get { return self.assessmentAggregate }
        set { self.assessmentAggregate = newValue }
    }
    var dataMyAssessment: Assessment? {
        get { return self.myAssessment }
        set { self.myAssessment = newValue }
    }
    
}