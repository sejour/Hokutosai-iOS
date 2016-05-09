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
    
    class News {
        
        static let basePath = "/news"
        
        class Timeline: HokutosaiApiEndpoint<ArrayResource<Article>> {
            init() { super.init(basePath: basePath, path: "/timeline") }
        }
        
        class Topics: HokutosaiApiEndpoint<ArrayResource<TopicNews>> {
            init() { super.init(basePath: basePath, path: "/topics", requiredAccount: false) }
        }
        
        class Details: HokutosaiApiEndpoint<ObjectResource<Article>> {
            init(newsId: UInt) { super.init(basePath: basePath, path: "/\(newsId)/details") }
        }
        
        class Likes: HokutosaiApiEndpoint<ObjectResource<NewsLikeResult>> {
            init(newsId: UInt) { super.init(basePath: basePath, path: "/\(newsId)/likes") }
        }
        
    }
    
    class Events {
        
        static let basePath = "/events"
        
        class Events: HokutosaiApiEndpoint<ArrayResource<Event>> {
            init() { super.init(basePath: basePath) }
        }
        
        class Schedules: HokutosaiApiEndpoint<ArrayResource<Schedule>> {
            init() { super.init(basePath: basePath, path: "/schedules") }
        }
        
        class Topics: HokutosaiApiEndpoint<ArrayResource<TopicEvent>> {
            init() { super.init(basePath: basePath, path: "/topics", requiredAccount: false) }
        }
        
        class Details: HokutosaiApiEndpoint<ObjectResource<Event>> {
            init(eventId: UInt) { super.init(basePath: basePath, path: "/\(eventId)/details") }
        }
        
        class Likes: HokutosaiApiEndpoint<ObjectResource<EventLikeResult>> {
            init(eventId: UInt) { super.init(basePath: basePath, path: "/\(eventId)/likes") }
        }
        
    }
    
    class Shops {
        
        static let basePath = "/shops"
        
        class Shops: HokutosaiApiEndpoint<ArrayResource<Shop>> {
            init() { super.init(basePath: basePath) }
            init(shopId: UInt) { super.init(basePath: basePath, path: "/\(shopId)") }
        }
        
        class Details: HokutosaiApiEndpoint<ObjectResource<DetailedShop>> {
            init(shopId: UInt) { super.init(basePath: basePath, path: "/\(shopId)/details") }
        }
        
        class Assessments: HokutosaiApiEndpoint<ObjectResource<AssessmentList>> {
            init(shopId: UInt) { super.init(basePath: basePath, path: "/\(shopId)/assessments") }
        }
        
        class Assessment: HokutosaiApiEndpoint<ObjectResource<ShopMyAssessment>> {
            init(shopId: UInt) { super.init(basePath: basePath, path: "/\(shopId)/assessment") }
        }
        
        class Likes: HokutosaiApiEndpoint<ObjectResource<ShopLikeResult>> {
            init(shopId: UInt) { super.init(basePath: basePath, path: "/\(shopId)/likes") }
        }
        
    }
    
    class Exhibitions {
        
        static let basePath = "/exhibitions"
        
        class Exhibitions: HokutosaiApiEndpoint<ArrayResource<Exhibition>> {
            init() { super.init(basePath: basePath) }
            init(exhibitionId: UInt) { super.init(basePath: basePath, path: "/\(exhibitionId)") }
        }
        
        class Details: HokutosaiApiEndpoint<ObjectResource<DetailedExhibition>> {
            init(exhibitionId: UInt) { super.init(basePath: basePath, path: "/\(exhibitionId)/details") }
        }
        
        class Assessments: HokutosaiApiEndpoint<ObjectResource<AssessmentList>> {
            init(exhibitionId: UInt) { super.init(basePath: basePath, path: "/\(exhibitionId)/assessments") }
        }
        
        class Assessment: HokutosaiApiEndpoint<ObjectResource<ExhibitionMyAssessment>> {
            init(exhibitionId: UInt) { super.init(basePath: basePath, path: "/\(exhibitionId)/assessment") }
        }
        
        class Likes: HokutosaiApiEndpoint<ObjectResource<ExhibitionLikeResult>> {
            init(exhibitionId: UInt) { super.init(basePath: basePath, path: "/\(exhibitionId)/likes") }
        }
        
    }
    
    class Accounts {
        
        static let basePath = "/accounts"
        
        class New: HokutosaiApiEndpoint<ObjectResource<HokutosaiAccount>> {
            init() { super.init(basePath: basePath, path: "/new", requiredAccount: false) }
        }
        
    }
    
}