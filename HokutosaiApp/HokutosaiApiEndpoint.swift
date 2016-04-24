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
    let requiredAccount: Bool
    
    init (basePath: String, requiredAccount: Bool = true) {
        self.requiredAccount = requiredAccount
        super.init(baseUrl: baseUrl, path: basePath)
    }
    
    init (basePath: String, path: String, requiredAccount: Bool = true) {
        self.requiredAccount = requiredAccount
        super.init(baseUrl: baseUrl, path: basePath + path)
    }
    
}

extension HokutosaiApi {
    
    class Shops {
        
        static let basePath = "/shops"
        
        class Shops: HokutosaiApiEndpoint<ArrayResource<Shop>> {
            init() { super.init(basePath: basePath) }
        }
        
        class Details: HokutosaiApiEndpoint<ObjectResource<DetailedShop>> {
            init(shopId: UInt) { super.init(basePath: basePath, path: "/\(shopId)/details") }
        }
        
    }
    
    class Accounts {
        
        static let basePath = "/accounts"
        
        class New: HokutosaiApiEndpoint<ObjectResource<HokutosaiAccount>> {
            init() { super.init(basePath: basePath, path: "/new", requiredAccount: false) }
        }
        
    }
    
}