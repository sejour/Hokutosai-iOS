//
//  MainTabViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    convenience init () {
        self.init(nibName: nil, bundle: NSBundle.mainBundle())
    }
    
    override init (nibName: String?, bundle: NSBundle?) {
        super.init(nibName: nibName, bundle: bundle)
        
        var viewControllers: [UIViewController] = []
        
        self.setViewControllers(viewControllers, animated: false)
        self.selectedIndex = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
