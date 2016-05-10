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
                   title: title,
                   introductionLabelTitle: "出店者から"
        )
    }
    
    init(shop: Shop, shopViewController: ShopsViewController) {
        let shopId = shop.shopId!
        super.init(endpointModel: HokutosaiApi.Shops.One(shopId: shopId),
                   endpointLikes: HokutosaiApi.Shops.Likes(shopId: shopId),
                   endpointAssessmentList: HokutosaiApi.Shops.Assessments(shopId: shopId),
                   endpointAssessment: HokutosaiApi.Shops.Assessment(shopId: shopId),
                   model: shop,
                   tableViewController: shopViewController,
                   introductionLabelTitle: "出店者から"
        )
    }
    
    override func generateContents(model: Shop) {
        super.generateContents(model)
        
        //
        self.insertSpace(10.0)
        //
        
        // 見出し
        self.addContentView(InformationLabel(width: self.view.width, icon: SharedImage.bookIcon, text: "メニュー"))
        
        //
        self.insertSpace(5.0)
        //
        
        if let menus = model.menus {
            for item in menus {
                self.addContentView(MenuItemLabel(width: self.view.width, item: item))
                self.insertSpace(5.0)
            }
        }
        
        // ---
        self.insertSpace(5.0)
        self.insertSeparator(20.0)
        // ---
    }
    
}