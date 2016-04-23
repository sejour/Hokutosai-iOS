//
//  AssessedScore.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class AssessedScore: Mappable {
    
    var assessedCount: Int?
    var totalScore: Int?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.assessedCount <- map["assessed_count"]
        self.totalScore <- map["total_score"]
    }
    
}