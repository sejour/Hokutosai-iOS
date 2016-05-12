//
//  UIScrollViewExtension.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/01.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func setContentAndScrollInsets(insets: UIEdgeInsets) {
        self.contentInset = insets
        self.scrollIndicatorInsets = insets
    }
    
}