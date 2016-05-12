//
//  ArticleMetaLabel.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/11.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class ArticleMetaLabel: UIView {
    
    private static let sideMargin: CGFloat = 20.0
    private static let betweenMargin: CGFloat = 8.0
    private static let viewHeight: CGFloat = 20.0

    convenience init(width: CGFloat, relatedTitle: String?, target: AnyObject?, action: Selector, datetime: NSDate?) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), relatedTitle: relatedTitle, target: target, action: action, datetime: datetime)
    }
    
    init(frame: CGRect, relatedTitle: String?, target: AnyObject?, action: Selector, datetime: NSDate?) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let datetimeLabel = UILabel()
        datetimeLabel.textColor = UIColor.grayColor()
        datetimeLabel.font = UIFont.systemFontOfSize(14)
        datetimeLabel.textAlignment = .Right
        datetimeLabel.numberOfLines = 1
        datetimeLabel.text = datetime != nil ? NSDate.stringFromDate(datetime!, format: "yyyy/MM/dd HH:mm") : "投稿時間不明"
        datetimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(datetimeLabel)
        datetimeLabel.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.right.equalTo(self).offset(-ArticleMetaLabel.sideMargin)
            make.height.equalTo(ArticleMetaLabel.viewHeight)
        }
        
        if relatedTitle != nil {
            datetimeLabel.setNeedsLayout()
            datetimeLabel.layoutIfNeeded()
        
            let relatedLabel = UILabel()
            relatedLabel.textColor = SharedColor.linkColor
            relatedLabel.font = UIFont.systemFontOfSize(16)
            relatedLabel.textAlignment = .Left
            relatedLabel.numberOfLines = 1
            relatedLabel.text = relatedTitle
            relatedLabel.userInteractionEnabled = true
            relatedLabel.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
            relatedLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(relatedLabel)
            relatedLabel.snp_makeConstraints { make in
                make.top.equalTo(self)
                make.left.equalTo(self).offset(ArticleMetaLabel.sideMargin)
                make.right.equalTo(datetimeLabel.left - ArticleMetaLabel.betweenMargin)
                make.height.equalTo(ArticleMetaLabel.viewHeight)
            }
        }
        
        self.snp_makeConstraints { make in
            make.width.equalTo(self.width)
            make.height.equalTo(ArticleMetaLabel.viewHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
