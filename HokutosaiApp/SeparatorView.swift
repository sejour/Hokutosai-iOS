//
//  SeparatorView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/08.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class SeparatorView: UIView {

    init (origin: CGFloat, length: CGFloat, color: UIColor?, width: CGFloat) {
        super.init(frame: CGRect(x: origin, y: 0.0, width: length, height: width))
        self.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var color: UIColor? {
        get { return self.backgroundColor }
        set { self.backgroundColor = newValue }
    }

}
