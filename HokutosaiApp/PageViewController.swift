//
//  PageViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/29.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pages = [UIViewController]()
    
    var pageCount: Int {
        return self.pages.count
    }
    
    var currentPageNumber: Int? {
        guard let vc = self.viewControllers, let index = self.pages.indexOf(vc[0]) else {
            return nil
        }
        
        return index
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.currentPageNumber where index > 0 else {
            return nil
        }
        
        return self.pages[index - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.currentPageNumber where index < self.pageCount - 1 else {
            return nil
        }
        
        return self.pages[index + 1]
    }


}
