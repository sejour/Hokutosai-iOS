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
    
    private class func call<ModelType: Mappable, ErrorType: Mappable>(method: Alamofire.Method, url: URLStringConvertible, recipient: ((HttpResponse<[ModelType], ErrorType>) -> Void)) {
        Alamofire.request(method, url).responseJSON { response in
            guard response.result.isSuccess else {
                recipient(HttpResponse<[ModelType], ErrorType>(isSuccess: false, response: response, model: nil, error: nil))
                return
            }
            
            guard response.response?.statusCode < 400 else {
                let error = Mapper<ErrorType>().map(response.result.value)
                recipient(HttpResponse<[ModelType], ErrorType>(isSuccess: false, response: response, model: nil, error: error))
                return
            }
            
            let model = Mapper<ModelType>().mapArray(response.result.value)
            recipient(HttpResponse<[ModelType], ErrorType>(isSuccess: model != nil, response: response, model: model, error: nil))
        }
    }
    
    private class func call<ModelType: Mappable, ErrorType: Mappable>(method: Alamofire.Method, url: URLStringConvertible, recipient: ((HttpResponse<ModelType, ErrorType>) -> Void)) {
        Alamofire.request(method, url).responseJSON { response in
            guard response.result.isSuccess else {
                recipient(HttpResponse<ModelType, ErrorType>(isSuccess: false, response: response, model: nil, error: nil))
                return
            }
            
            guard response.response?.statusCode < 400 else {
                let error = Mapper<ErrorType>().map(response.result.value)
                recipient(HttpResponse<ModelType, ErrorType>(isSuccess: false, response: response, model: nil, error: error))
                return
            }
            
            let model = Mapper<ModelType>().map(response.result.value)
            recipient(HttpResponse<ModelType, ErrorType>(isSuccess: model != nil, response: response, model: model, error: nil))
        }
    }
    
}
