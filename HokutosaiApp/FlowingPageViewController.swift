//
//  FlowingPageViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/29.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class FlowingPageViewController: SlidePageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(navigationOrientation: UIPageViewControllerNavigationOrientation = .Horizontal) {
        super.init(navigationOrientation: navigationOrientation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.currentPageNumber else {
            return nil
        }
        
        let nextIndex = index <= 0 ? self.pageCount - 1 : index - 1
        
        return self.pages[nextIndex]
    }
    
    override func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.currentPageNumber else {
            return nil
        }
        
        let nextIndex = index >= self.pageCount - 1 ? 0 : index + 1
        
        return self.pages[nextIndex]
    }

}
