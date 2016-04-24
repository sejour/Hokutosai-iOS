//
//  HokutosaiAccount.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/23.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import ObjectMapper

class HokutosaiAccount: Mappable {
    
    var accountId: String?
    var accountPass: String?
    var userName: String?
    var mediaUrl: String?
    
    init (accountId: String?, accountPass: String?, userName: String?, mediaUrl: String?) {
        self.accountId = accountId
        self.accountPass = accountPass
        self.userName = userName
        self.mediaUrl = mediaUrl
    }
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.accountId <- map["account_id"]
        self.accountPass <- map["account_pass"]
        self.userName <- map["user_name"]
        self.mediaUrl <- map["media_url"]
    }
    
}
