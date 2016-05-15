//
//  Exhibition.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/28.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class Exhibition: StandardContentsData {
    
    var exhibitionId: UInt?
    var title: String?
    var exhibitor: String?
    var displays: String?
    var imageUrl: String?
    var assessmentAggregate: AssessedScore?
    var liked: Bool?
    var likesCount: UInt?
    var introduction: String?
    var place: Place?
    var myAssessment: Assessment?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.exhibitionId <- map["exhibition_id"]
        self.title <- map["title"]
        self.exhibitor <- map["exhibitors"]
        self.displays <- map["displays"]
        self.imageUrl <- map["image_url"]
        self.assessmentAggregate <- map["assessment_aggregate"]
        self.liked <- map["liked"]
        self.likesCount <- map["likes_count"]
        self.introduction <- map["introduction"]
        self.place <- map["place"]
        self.myAssessment <- map["my_assessment"]
    }
    
    var dataId: UInt { return self.exhibitionId! }
    var dataImageUrl: String? { return self.imageUrl }
    var dataTitle: String? { return self.title }
    var dataOrganizer: String? { return self.exhibitor }
    var dataDescription: String? { return self.displays }
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