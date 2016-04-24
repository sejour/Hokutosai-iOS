//
//  User.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    var accountId: String?
    var userName: String?
    var mediaUrl: String?
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        self.accountId <- map["account_id"]
        self.userName <- map["user_name"]
        self.mediaUrl <- map["media_url"]
    }
    
}