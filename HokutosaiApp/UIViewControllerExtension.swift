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
    
    static var pixelWidth: CGFloat {
        return 1.0 / UIScreen.mainScreen().scale
    }
    
    func hideNavigationBackButtonText() {
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
    }
    
    func hiddenTopBar(hidden: Bool, animated: Bool) {
        if self.navigationController?.navigationBarHidden != hidden {
            if hidden {
                self.navigationController?.setNavigationBarHidden(hidden, animated: animated)
                UIApplication.sharedApplication().setStatusBarHidden(hidden, withAnimation: animated ? .Slide : .None)
            } else {
                UIApplication.sharedApplication().setStatusBarHidden(hidden, withAnimation: animated ? .Slide : .None)
                self.navigationController?.setNavigationBarHidden(hidden, animated: animated)
            }
        }
    }
    
}