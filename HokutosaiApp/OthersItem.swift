//
//  OthersItem.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/15.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation

class OthersItem {
    
    let title: String
    let url: String?
    
    init(title: String, url: String?) {
        self.title = title
        self.url = url
    }
    
}

class OthersSection {
    
    let title: String?
    let items: [OthersItem]
    
    init(title: String?, items: [OthersItem]) {
        self.title = title
        self.items = items
    }
    
}