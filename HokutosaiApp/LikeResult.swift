//
//  LikeResult.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class LikeResult: Mappable {
    
    var likesCount: UInt?
    var liked: Bool?
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        self.likesCount <- map["likes_count"]
        self.liked <- map["liked"]
    }
    
}