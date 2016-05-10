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

protocol MutableContentsController: class {
    
    var requiredToUpdateWhenWillEnterForeground: Bool { get }
    var requiredToUpdateWhenDidChengeTab: Bool { get }
    
    func updateContents()
    
}

class MainTabViewController: UITabBarController {

    private var navigationControllers: [UINavigationController]!
    private var firstViewControllers: [UIViewController]!
    
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
        
        let newsViewController = NewsViewController()
        newsViewController.hideNavigationBackButtonText()
        let newsController = UINavigationController(rootViewController: newsViewController)
        newsController.tabBarItem = UITabBarItem(title: "お知らせ", image: UIImage(named: "TabBarIconNews"), tag: self.newsTag)
        
        let eventsViewController = EventsViewController()
        eventsViewController.hideNavigationBackButtonText()
        let eventsController = UINavigationController(rootViewController: eventsViewController)
        eventsController.tabBarItem = UITabBarItem(title: "企画", image: UIImage(named: "TabBarIconEvent"), tag: self.eventsTag)
        
        let shopsViewController = ShopsViewController()
        shopsViewController.hideNavigationBackButtonText()
        let shopsController = UINavigationController(rootViewController: shopsViewController)
        shopsController.tabBarItem = UITabBarItem(title: "模擬店", image: UIImage(named: "TabBarIconShop"), tag: self.shopsTag)
        
        let exhibitionsViewController = ExhibitionsViewController()
        exhibitionsViewController.hideNavigationBackButtonText()
        let exhibitionsController = UINavigationController(rootViewController: exhibitionsViewController)
        exhibitionsController.tabBarItem = UITabBarItem(title: "展示", image: UIImage(named: "TabBarIconExhibition"), tag: self.exhibitionsTag)
        
        self.firstViewControllers = [newsViewController, eventsViewController, shopsViewController, exhibitionsViewController]
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

    // Foregroundになるとき
    func updateContents() {
        // 今開いているタブのViewControllerStackを全て更新(更新がrequiredなものだけ)
        for controller in self.navigationControllers[self.selectedIndex].childViewControllers {
            if let mutableContentsController = controller as? MutableContentsController where mutableContentsController.requiredToUpdateWhenWillEnterForeground {
                mutableContentsController.updateContents()
            }
        }
    }
    
    // タブが変わる時
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let visibleController = self.navigationControllers[item.tag].visibleViewController
        
        // self.selectedIndex: previous tab index
        // item.tag: new tab index
        if self.selectedIndex == item.tag {
            if let tabBarInteractiveControler = visibleController as? TabBarIntaractiveController {
                tabBarInteractiveControler.tabBarIconTapped()
            }
        }
        else {
            if let mutableContentsController = visibleController as? MutableContentsController where mutableContentsController.requiredToUpdateWhenDidChengeTab {
                mutableContentsController.updateContents()
            }
        }
    }
    
}
