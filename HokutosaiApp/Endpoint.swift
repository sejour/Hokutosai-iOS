//
//  Endpoint.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/23.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Endpoint<ResourceType: NetworkResource, ErrorType: Mappable> {
    
    private let _resource: ResourceType
    
    var resource: ResourceType {
        return self.resource
    }
    
    var url: URLStringConvertible {
        return self.resource.url
    }
    
    init (baseUrl: String, path: String) {
        self._resource = ResourceType(url: "\(baseUrl)\(path)")
    }
    
}