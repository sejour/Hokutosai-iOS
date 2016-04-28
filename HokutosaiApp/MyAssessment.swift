//
//  MyAssessment.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class MyAssessment: Mappable {
    
    var myAssessment: Assessment?
    var assessmentAggregate: AssessedScore?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.myAssessment <- map["my_assessment"]
        self.assessmentAggregate <- map["assessment_aggregate"]
    }
    
}
