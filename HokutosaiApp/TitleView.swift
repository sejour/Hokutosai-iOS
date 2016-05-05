//
//  TitleView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/05.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class TitleView: UIView {
    
    let iconSize: CGFloat = 40.0
    
    convenience init(width: CGFloat, title: String, featured: Bool?) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), title: title, featured: featured ?? false)
    }
    
    init(frame: CGRect, title: String, featured: Bool) {
        super.init(frame: frame)

        var labelLeft = self.snp_left
        if featured {
            let icon = UIImageView(image: SharedImage.starRibbonIcon)
            icon.contentMode = .ScaleAspectFit
            self.addSubview(icon)
            icon.snp_makeConstraints { make in
                make.top.equalTo(self)
                make.left.equalTo(self).offset(20.0)
                make.width.height.equalTo(self.iconSize)
            }
            labelLeft = icon.snp_right
        }
        
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.boldSystemFontOfSize(25)
        label.textAlignment = .Left
        label.numberOfLines = 0
        label.text = title
        self.addSubview(label)
        label.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(labelLeft).offset(featured ? 8.0 : 20.0)
            make.right.equalTo(self).offset(-15.0)
            make.height.greaterThanOrEqualTo(self.iconSize)
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
