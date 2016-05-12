//
//  AssessmentReportCause.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/13.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class AssessmentReportCause: Mappable {
    
    var causeId: String?
    var text: String?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.causeId <- map["cause_id"]
        self.text <- map["text"]
    }
    
}