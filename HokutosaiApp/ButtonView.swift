//
//  ButtonView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/13.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class ButtonView: UIView {
    
    class Property {
        var color: UIColor = SharedColor.linkColor
        var font: UIFont = UIFont.systemFontOfSize(20.0)
        var alignment: NSTextAlignment = .Center
    }

    convenience init(width: CGFloat, text: String, target: AnyObject?, action: Selector, property: Property = Property()) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), text: text, target: target, action: action, property: property)
    }
    
    init(frame: CGRect, text: String, target: AnyObject?, action: Selector, property: Property = Property()) {
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        
        let label = UILabel()
        label.textColor = property.color
        label.font = property.font
        label.textAlignment = property.alignment
        label.numberOfLines = 1
        label.text = text
        self.addSubview(label)
        label.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20.0)
            make.right.equalTo(self).offset(-20.0)
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

}
