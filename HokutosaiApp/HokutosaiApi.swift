//
//  HokutosaiApi.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/23.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class HokutosaiApi {
    
    private static let apiUserId = "client-ios-app"
    private static let apiAccessToken = "hJixYqBgFOMgOvvXy8pbZ84JrNfuV8a2PKaMedhvFKj87AKGPtla19HKRKqsPya3"
    
    private static var account: HokutosaiAccount?
    
    private static let authorizationHeaderName = "Authorization"
    private static var autorizationHeaderValue: String {
        var value = "user_id=\(apiUserId),access_token=\(apiAccessToken)"
        
        if let account = account {
            value += ",account_id=\(account.accountId),account_pass=\(account.accountPass)"
        }

        return value
    }
    
    class func call<ModelType: Mappable, ErrorType: Mappable>(
        method: Alamofire.Method,
        url: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        recipient: ((HttpResponse<[ModelType], ErrorType>) -> Void))
    {
        var requestHeaders = [String: String]()
        if let headers = headers { requestHeaders += headers }
        requestHeaders[authorizationHeaderName] = HokutosaiApi.autorizationHeaderValue
        
        REST.call(.GET, url: url, parameters: parameters, encoding: encoding, headers: requestHeaders, recipient: recipient)
    }
    
    class func call<ModelType: Mappable, ErrorType: Mappable>(
        method: Alamofire.Method,
        url: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        recipient: ((HttpResponse<ModelType, ErrorType>) -> Void))
    {
        var requestHeaders = [String: String]()
        if let headers = headers { requestHeaders += headers }
        requestHeaders[authorizationHeaderName] = HokutosaiApi.autorizationHeaderValue
        
        REST.call(.GET, url: url, parameters: parameters, encoding: encoding, headers: requestHeaders, recipient: recipient)
    }
    
}

func += <KeyType, ValueType> (inout left: [KeyType: ValueType], right: [KeyType: ValueType]) {
    for (key, value) in right {
        left.updateValue(value, forKey: key)
    }
}