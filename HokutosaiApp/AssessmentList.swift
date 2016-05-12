//
//  AssessmentList.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/09.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class AssessmentList: Mappable {
    
    var assessments: [Assessment]?
    var myAssessment: Assessment?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.assessments <- map["assessments"]
        self.myAssessment <- map["my_assessment"]
    }
    
}