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
    
    class func GET<ModelType: Mappable, ResourceType: ArrayResource<ModelType>, ErrorType: Mappable>(endpoint: Endpoint<ResourceType, ErrorType>, recipient: ((HttpResponse<[ModelType], ErrorType>) -> Void)) {
        call(.GET, url: endpoint.url, recipient: recipient)
    }
    
    class func GET<ModelType: Mappable, ResourceType: ObjectResource<ModelType>, ErrorType: Mappable>(endpoint: Endpoint<ResourceType, ErrorType>, recipient: ((HttpResponse<ModelType, ErrorType>) -> Void)) {
        call(.GET, url: endpoint.url, recipient: recipient)
    }
    
    class func POST<ModelType: Mappable, ResourceType: ArrayResource<ModelType>, ErrorType: Mappable>(endpoint: Endpoint<ResourceType, ErrorType>, recipient: ((HttpResponse<[ModelType], ErrorType>) -> Void)) {
        call(.POST, url: endpoint.url, recipient: recipient)
    }
    
    class func POST<ModelType: Mappable, ResourceType: ObjectResource<ModelType>, ErrorType: Mappable>(endpoint: Endpoint<ResourceType, ErrorType>, recipient: ((HttpResponse<ModelType, ErrorType>) -> Void)) {
        call(.POST, url: endpoint.url, recipient: recipient)
    }
    
    class func PUT<ModelType: Mappable, ResourceType: ArrayResource<ModelType>, ErrorType: Mappable>(endpoint: Endpoint<ResourceType, ErrorType>, recipient: ((HttpResponse<[ModelType], ErrorType>) -> Void)) {
        call(.PUT, url: endpoint.url, recipient: recipient)
    }
    
    class func PUT<ModelType: Mappable, ResourceType: ObjectResource<ModelType>, ErrorType: Mappable>(endpoint: Endpoint<ResourceType, ErrorType>, recipient: ((HttpResponse<ModelType, ErrorType>) -> Void)) {
        call(.PUT, url: endpoint.url, recipient: recipient)
    }
    
    class func DELETE<ModelType: Mappable, ResourceType: ArrayResource<ModelType>, ErrorType: Mappable>(endpoint: Endpoint<ResourceType, ErrorType>, recipient: ((HttpResponse<[ModelType], ErrorType>) -> Void)) {
        call(.DELETE, url: endpoint.url, recipient: recipient)
    }
    
    class func DELETE<ModelType: Mappable, ResourceType: ObjectResource<ModelType>, ErrorType: Mappable>(endpoint: Endpoint<ResourceType, ErrorType>, recipient: ((HttpResponse<ModelType, ErrorType>) -> Void)) {
        call(.DELETE, url: endpoint.url, recipient: recipient)
    }
    
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
