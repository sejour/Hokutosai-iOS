//
//  LinkedInformationLabel.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/12.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class LinkedInformationLabel: UIView {
    
    private var label: UILabel!
    private var iconView: UIImageView!
    
    convenience init(width: CGFloat, icon: UIImage?, text: String?, target: AnyObject?, action: Selector, iconSize: CGFloat = 22.0) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), icon: icon, text: text, target: target, action: action, iconSize: iconSize)
    }
    
    init(frame: CGRect, icon: UIImage?, text: String?, target: AnyObject?, action: Selector, iconSize: CGFloat = 22.0) {
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
        
        self.iconView = UIImageView(image: icon)
        self.iconView.contentMode = .ScaleAspectFit
        self.addSubview(iconView)
        self.iconView.snp_makeConstraints { make in
            make.width.height.equalTo(iconSize)
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20.0)
        }
        
        self.label = UILabel()
        self.label.textColor = UIColor.blueColor()
        self.label.font = UIFont.systemFontOfSize(16)
        self.label.textAlignment = .Left
        self.label.numberOfLines = 0
        self.label.text = text
        self.addSubview(label)
        self.label.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(iconView.snp_right).offset(8.0)
            make.right.equalTo(self).offset(-15.0)
            make.height.greaterThanOrEqualTo(iconSize)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.snp_makeConstraints { make in
            make.width.equalTo(self.width)
            make.height.equalTo(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var text: String? {
        get { return self.label.text }
        set { self.label.text = newValue }
    }
    
    var icon: UIImage? {
        get { return self.iconView.image }
        set { self.iconView.image = newValue }
    }
    
}
