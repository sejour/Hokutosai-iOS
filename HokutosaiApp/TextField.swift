//
//  TextField.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/14.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class TextField: UIView {
    
    class Property {
        var defaultText: String?
        var placeholder: String?
        var font: UIFont = UIFont.systemFontOfSize(20.0)
        var textColor: UIColor = UIColor.blackColor()
        var alignment: NSTextAlignment = .Left
    }
    
    private static let viewHeight: CGFloat = 22.0

    convenience init(width: CGFloat, property: Property = Property()) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), property: property)
    }
    
    init(frame: CGRect, property: Property = Property()) {
        super.init(frame: frame)
        
        let textField = UITextField()
        textField.font = property.font
        textField.textColor = property.textColor
        textField.textAlignment = property.alignment
        textField.text = property.defaultText
        textField.placeholder = property.placeholder
        
        self.addSubview(textField)
        textField.snp_makeConstraints { make in
            make.left.equalTo(self).offset(20.0)
            make.right.equalTo(self).offset(-20.0)
            make.top.equalTo(self)
            make.height.equalTo(TextField.viewHeight)
        }
        
        self.snp_makeConstraints { make in
            make.width.equalTo(self.width)
            make.height.equalTo(TextField.viewHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
