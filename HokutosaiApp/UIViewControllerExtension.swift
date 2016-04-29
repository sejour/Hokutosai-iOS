//
//  UIViewControllerExtension.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/30.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var appearOriginY: CGFloat {
        var originY = UIApplication.sharedApplication().statusBarFrame.size.height
        
        if let navigationController = self.navigationController {
            originY += navigationController.navigationBar.frame.size.height
        }
        
        return originY
    }
    
}