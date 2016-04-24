//
//  Place.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class Place: Mappable {
    
    var placeId: Int?
    var name: String?
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        self.placeId <- map["place_id"]
        self.name <- map["name"]
    }
    
}