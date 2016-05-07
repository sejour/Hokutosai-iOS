//
//  HorizontalArrangeView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/06.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class HorizontalArrangeView: UIView {
    
    convenience init(width: CGFloat, height: CGFloat, items: [UIView], horizontalMargin: CGFloat = 10.0) {
        self.init(size: CGSize(width: width, height: height), items: items)
    }

    init(size: CGSize, items: [UIView], horizontalMargin: CGFloat = 10.0) {
        super.init(frame: CGRect(origin: CGPointZero, size: size))
        
        let space = self.width / CGFloat(items.count + 1)
        var width = space - horizontalMargin
        if width < self.height { width = self.height }
        let centerY = self.height / 2.0
        
        for i in 0 ..< items.count {
            items[i].size = CGSize(width: width, height: self.height)
            items[i].center = CGPoint(x: space * CGFloat(i + 1), y: centerY)
            items[i].contentMode = .ScaleAspectFit
            self.addSubview(items[i])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
