//
//  HokutosaiApiEndpoint.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/23.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation

class HokutosaiApiEndpoint<ResourceType: NetworkResource>: Endpoint<ResourceType, HokutosaiApiError> {
    
    let baseUrl = "https://api.hokutosai.tech/2016"
    
    init (path: String) {
        super.init(baseUrl: baseUrl, path: path)
    }
    
}

extension HokutosaiApi {
    
    class Shops {
        class Shops: HokutosaiApiEndpoint<ArrayResource<Shop>> {
            init() { super.init(path: "/shops") }
        }
    }
    
}