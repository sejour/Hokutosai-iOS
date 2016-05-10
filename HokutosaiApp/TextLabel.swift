//
//  TextLabel.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/06.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class TextLabel: UIView {
    
    class Property {
        var color: UIColor = UIColor.blackColor()
        var font: UIFont = UIFont.systemFontOfSize(17.0)
        var alignment: NSTextAlignment = .Left
    }
    
    convenience init(width: CGFloat, text: String?, property: Property = Property()) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), text: text, property: property)
    }
    
    init(frame: CGRect, text: String?, property: Property) {
        super.init(frame: frame)
        
        let label = UILabel()
        label.textColor = property.color
        label.font = property.font
        label.textAlignment = property.alignment
        label.numberOfLines = 0
        label.text = text
        self.addSubview(label)
        label.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20.0)
            make.right.equalTo(self).offset(-15.0)
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
