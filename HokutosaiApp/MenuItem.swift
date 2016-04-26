//
//  MenuItem.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class MenuItem: Mappable {
    
    var itemId: UInt?
    var name: String?
    var price: Int?
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        self.itemId <- map["item_id"]
        self.name <- map["name"]
        self.price <- map["price"]
    }
    
}