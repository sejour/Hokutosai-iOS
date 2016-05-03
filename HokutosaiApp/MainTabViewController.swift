//
//  MainTabViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol TabBarIntaractiveController {
    
    func tabBarIconTapped()
    
}

class MainTabViewController: UITabBarController {

    private var navigationControllers: [UINavigationController]!
    
    private var newsViewController: NewsViewController!
    private var eventsViewController: EventsViewController!
    private var shopsViewController: ShopsViewController!
    private var exhibitionsViewController: ExhibitionsViewController!
    
    private let newsTag: Int = 0
    private let eventsTag: Int = 1
    private let shopsTag: Int = 2
    private let exhibitionsTag: Int = 3
    
    static let mainController = MainTabViewController(nibName: nil, bundle: NSBundle.mainBundle())
    
    private override init (nibName: String?, bundle: NSBundle?) {
        super.init(nibName: nibName, bundle: bundle)
        
        UINavigationBar.appearance().barTintColor = SharedColor.themeColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UITabBar.appearance().tintColor = SharedColor.themeColor
        
        self.newsViewController = NewsViewController()
        self.newsViewController.hideNavigationBackButtonText()
        let newsController = UINavigationController(rootViewController: self.newsViewController)
        newsController.tabBarItem = UITabBarItem(title: "お知らせ", image: UIImage(named: "TabBarIconNews"), tag: self.newsTag)
        
        self.eventsViewController = EventsViewController()
        self.eventsViewController.hideNavigationBackButtonText()
        let eventsController = UINavigationController(rootViewController: self.eventsViewController)
        eventsController.tabBarItem = UITabBarItem(title: "スケジュール", image: UIImage(named: "TabBarIconEvent"), tag: self.eventsTag)
        
        self.shopsViewController = ShopsViewController()
        self.shopsViewController.hideNavigationBackButtonText()
        let shopsController = UINavigationController(rootViewController: self.shopsViewController)
        shopsController.tabBarItem = UITabBarItem(title: "模擬店", image: UIImage(named: "TabBarIconShop"), tag: self.shopsTag)
        
        self.exhibitionsViewController = ExhibitionsViewController()
        self.exhibitionsViewController.hideNavigationBackButtonText()
        let exhibitionsController = UINavigationController(rootViewController: self.exhibitionsViewController)
        exhibitionsController.tabBarItem = UITabBarItem(title: "展示", image: UIImage(named: "TabBarIconExhibition"), tag: self.exhibitionsTag)
        
        self.navigationControllers = [newsController, eventsController, shopsController, exhibitionsController]
        
        self.setViewControllers(self.navigationControllers, animated: false)
        self.selectedIndex = 0
    }
    
    private init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateContents() {
        self.newsViewController.updateContents()
        self.eventsViewController.updateContents()
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        // confirm retapping
        guard self.selectedIndex == item.tag else {
            return
        }
        
        if let controller = self.navigationControllers[self.selectedIndex].visibleViewController as? TabBarIntaractiveController {
            controller.tabBarIconTapped()
        }
    }
    
}
