//
//  REST.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/23.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class REST {
    
    private class func call<ModelType: Mappable, ErrorType: Mappable>(method: Alamofire.Method, url: URLStringConvertible, recipient: ((Bool, Result<AnyObject, NSError>, [ModelType]?, ErrorType?) -> Void)) {
        Alamofire.request(method, url).responseJSON { response in
            let result = response.result
            
            guard result.isSuccess else {
                recipient(false, result, nil, nil)
                return
            }
            
            guard response.response?.statusCode < 400 else {
                let error = Mapper<ErrorType>().map(result.value)
                recipient(false, result, nil, error)
                return
            }
            
            let model = Mapper<ModelType>().mapArray(result.value)
            recipient(model != nil, result, model, nil)
        }
    }
    
    private class func call<ModelType: Mappable, ErrorType: Mappable>(method: Alamofire.Method, url: URLStringConvertible, recipient: ((Bool, Result<AnyObject, NSError>, ModelType?, ErrorType?) -> Void)) {
        Alamofire.request(method, url).responseJSON { response in
            let result = response.result
            
            guard result.isSuccess else {
                recipient(false, result, nil, nil)
                return
            }
            
            guard response.response?.statusCode < 400 else {
                let error = Mapper<ErrorType>().map(result.value)
                recipient(false, result, nil, error)
                return
            }
            
            let model = Mapper<ModelType>().map(result.value)
            recipient(model != nil, result, model, nil)
        }
    }
    
}
