//
//  MainTabViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    private var newsViewController: NewsViewController!
    private var eventsViewController: EventsViewController!
    private var shopsViewController: ShopsViewController!
    private var exhibitionsViewController: ExhibitionsViewController!
    
    convenience init () {
        self.init(nibName: nil, bundle: NSBundle.mainBundle())
    }
    
    override init (nibName: String?, bundle: NSBundle?) {
        super.init(nibName: nibName, bundle: bundle)
        
        UINavigationBar.appearance().barTintColor = SharedColor.themeColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UITabBar.appearance().tintColor = SharedColor.themeColor
        
        var viewControllers = [UIViewController]()
        
        self.newsViewController = NewsViewController()
        let newsController = UINavigationController(rootViewController: self.newsViewController)
        newsController.tabBarItem = UITabBarItem(title: "お知らせ", image: UIImage(named: "TabBarIconNews"), tag: 0)
        viewControllers.append(newsController)
        
        self.eventsViewController = EventsViewController()
        let eventsController = UINavigationController(rootViewController: self.eventsViewController)
        eventsController.tabBarItem = UITabBarItem(title: "スケジュール", image: UIImage(named: "TabBarIconEvent"), tag: 1)
        viewControllers.append(eventsController)
        
        self.shopsViewController = ShopsViewController()
        let shopsController = UINavigationController(rootViewController: self.shopsViewController)
        shopsController.tabBarItem = UITabBarItem(title: "模擬店", image: UIImage(named: "TabBarIconShop"), tag: 2)
        viewControllers.append(shopsController)
        
        self.exhibitionsViewController = ExhibitionsViewController()
        let exhibitionsController = UINavigationController(rootViewController: self.exhibitionsViewController)
        exhibitionsController.tabBarItem = UITabBarItem(title: "展示", image: UIImage(named: "TabBarIconExhibition"), tag: 3)
        viewControllers.append(exhibitionsController)
        
        self.setViewControllers(viewControllers, animated: false)
        self.selectedIndex = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateContents() {
        self.newsViewController.updateContents()
    }
    
}
