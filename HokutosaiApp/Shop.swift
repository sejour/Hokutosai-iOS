//
//  Shop.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class Shop: Mappable {
    
    var shopId: UInt?
    var name: String?
    var tenant: String?
    var sales: String?
    var imageUrl: String?
    var assessmentAggregate: AssessedScore?
    var liked: Bool?
    var likesCount: Int?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.shopId <- map["shop_id"]
        self.name <- map["name"]
        self.tenant <- map["tenant"]
        self.sales <- map["sales"]
        self.imageUrl <- map["imageUrl"]
        self.assessmentAggregate <- map["assessment_aggregate"]
        self.liked <- map["liked"]
        self.likesCount <- map["likesCount"]
    }
    
}