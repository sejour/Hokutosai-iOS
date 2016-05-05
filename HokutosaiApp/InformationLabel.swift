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

    var iconView: UIImageView!
    var label: UILabel!
    
    convenience init(width: CGFloat, icon: UIImage?, text: String?) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), icon: icon, text: text)
    }
    
    init(frame: CGRect, icon: UIImage?, text: String?) {
        super.init(frame: frame)
    
        self.iconView = UIImageView(image: icon)
        self.iconView.contentMode = .ScaleAspectFit
        self.addSubview(self.iconView)
        self.iconView.snp_makeConstraints { make in
            make.width.equalTo(25.0)
            make.height.equalTo(25.0)
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20.0)
        }
        
        self.label = UILabel()
        self.label.textColor = UIColor.blackColor()
        self.label.font = UIFont.systemFontOfSize(18)
        self.label.textAlignment = .Left
        self.label.numberOfLines = 0
        self.label.text = text
        self.addSubview(self.label)
        self.label.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self.iconView.snp_right).offset(8.0)
            make.right.equalTo(self).offset(-20.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
