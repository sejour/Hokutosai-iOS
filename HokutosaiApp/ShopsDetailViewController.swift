//
//  ShopsDetailViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/09.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation

class ShopsDetailViewController: StandardDetailsViewController<Shop, ShopsViewController> {
    
    init(shopId: UInt, title: String?) {
        super.init(endpointModel: HokutosaiApi.Shops.One(shopId: shopId),
                   endpointLikes: HokutosaiApi.Shops.Likes(shopId: shopId),
                   endpointAssessmentList: HokutosaiApi.Shops.Assessments(shopId: shopId),
                   endpointAssessment: HokutosaiApi.Shops.Assessment(shopId: shopId),
                   title: title
        )
    }
    
    init(shop: Shop, shopViewController: ShopsViewController) {
        let shopId = shop.shopId!
        super.init(endpointModel: HokutosaiApi.Shops.One(shopId: shopId),
                   endpointLikes: HokutosaiApi.Shops.Likes(shopId: shopId),
                   endpointAssessmentList: HokutosaiApi.Shops.Assessments(shopId: shopId),
                   endpointAssessment: HokutosaiApi.Shops.Assessment(shopId: shopId),
                   model: shop,
                   tableViewController: shopViewController
        )
    }
    
    override func generateContents(model: Shop) {
        super.generateContents(model)
    }
    
}