//
//  DetailedExhibition.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/28.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class DetailedExhibition: Exhibition {
    
    var assessments: [Assessment]?
    var myAssessment: Assessment?
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        
        self.assessments <- map["assessments"]
        self.myAssessment <- map["my_assessment"]
    }
    
}