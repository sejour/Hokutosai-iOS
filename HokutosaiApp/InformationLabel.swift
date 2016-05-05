//
//  InformationLabel.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/05.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit
import SnapKit

class InformationLabel: UIView {
    
    convenience init(width: CGFloat, icon: UIImage?, text: String?, iconSize: CGFloat = 25.0) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), icon: icon, text: text)
    }
    
    init(frame: CGRect, icon: UIImage?, text: String?, iconSize: CGFloat = 25.0) {
        super.init(frame: frame)
    
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .ScaleAspectFit
        self.addSubview(iconView)
        iconView.snp_makeConstraints { make in
            make.width.height.equalTo(iconSize)
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20.0)
        }
        
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(18)
        label.textAlignment = .Left
        label.numberOfLines = 0
        label.text = text
        self.addSubview(label)
        label.snp_makeConstraints { make in
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
    
}
