//
//  Assessment.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class Assessment: Mappable {
    
    var user: User?
    var datetime: NSDate?
    var score: UInt?
    var comment: String?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.user <- map["user"]
        self.datetime <- (map["datetime"], HokutosaiDateTransform())
        self.score <- map["score"]
        self.comment <- map["comment"]
    }
    
}