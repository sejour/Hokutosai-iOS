//
//  MenuItemLabel.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/10.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class MenuItemLabel: UIView {
    
    private static let titleWidthRatio: CGFloat = 0.7
    private static let leftMargin: CGFloat = 20.0
    private static let betweenTitleAndPriceMargin: CGFloat = 8.0
    private static let rightMargin: CGFloat = 15.0
    
    convenience init(width: CGFloat, item: MenuItem) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), title: item.name, price: item.price)
    }
    
    convenience init(width: CGFloat, title: String?, price: Int?) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), title: title, price: price)
    }
    
    init(frame: CGRect, title: String?, price: Int?) {
        super.init(frame: frame)
        
        let contentWidth = self.width - MenuItemLabel.leftMargin - MenuItemLabel.betweenTitleAndPriceMargin - MenuItemLabel.rightMargin
        let titleWidth = contentWidth * MenuItemLabel.titleWidthRatio
        let priceWidth = contentWidth * (1.0 - MenuItemLabel.titleWidthRatio)
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.textAlignment = .Left
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20.0)
            make.width.equalTo(titleWidth)
        }
        
        // Price Label
        let priceLabel = UILabel()
        priceLabel.textColor = UIColor.blackColor()
        priceLabel.font = UIFont.systemFontOfSize(16)
        priceLabel.textAlignment = .Right
        priceLabel.numberOfLines = 0
        priceLabel.text = "\(price ?? 0)円"
        self.addSubview(priceLabel)
        priceLabel.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.right.equalTo(self).offset(-MenuItemLabel.rightMargin)
            make.width.equalTo(priceWidth)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.snp_makeConstraints { make in
            make.width.equalTo(self.width)
            make.height.equalTo(titleLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
