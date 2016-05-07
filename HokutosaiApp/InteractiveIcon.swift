//
//  InteractiveIcon.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/07.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class InteractiveIcon: UIImageView {
    
    convenience init(width: CGFloat, image: UIImage?, target: AnyObject?, action: Selector) {
        self.init(image: image, target: target, action: action)
        
        self.width = width
        self.height = width
    }
    
    init(image: UIImage?, target: AnyObject?, action: Selector) {
        super.init(image: image)
        
        self.userInteractionEnabled = true
        self.contentMode = .ScaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
