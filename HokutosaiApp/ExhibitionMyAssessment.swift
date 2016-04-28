//
//  ExhibitionMyAssessment.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/28.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class ExhibitionMyAssessment: MyAssessment {
    
    var exhibitionId: UInt?
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        
        self.exhibitionId <- map["exhibition_id"]
    }
    
}