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
    
    var score: UInt?
    var comment: String?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.score <- map["score"]
        self.comment <- map["comment"]
    }
    
}