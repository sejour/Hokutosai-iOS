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
        
        var viewControllers = [UIViewController]()
        
        let newsViewController = UINavigationController(rootViewController: NewsViewController())
        newsViewController.tabBarItem = UITabBarItem(title: "お知らせ", image: UIImage(named: "TabBarIconNews"), tag: 0)
        viewControllers.append(newsViewController)
        
        let eventsViewController = UINavigationController(rootViewController: EventsViewController())
        eventsViewController.tabBarItem = UITabBarItem(title: "スケジュール", image: UIImage(named: "TabBarIconEvent"), tag: 0)
        viewControllers.append(eventsViewController)
        
        let shopsViewController = UINavigationController(rootViewController: ShopsViewController())
        shopsViewController.tabBarItem = UITabBarItem(title: "模擬店", image: UIImage(named: "TabBarIconShop"), tag: 0)
        viewControllers.append(shopsViewController)
        
        let exhibitionsViewController = UINavigationController(rootViewController: ExhibitionsViewController())
        exhibitionsViewController.tabBarItem = UITabBarItem(title: "展示", image: UIImage(named: "TabBarIconExhibition"), tag: 0)
        viewControllers.append(exhibitionsViewController)
        
        self.setViewControllers(viewControllers, animated: false)
        self.selectedIndex = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
