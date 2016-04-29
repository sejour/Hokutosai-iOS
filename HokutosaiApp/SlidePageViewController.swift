//
//  SlidePageViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/29.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class SlidePageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    private var pages: [UIViewController]!
    
    var pageCount: Int {
        return self.pages.count
    }
    
    var currentPageNumber: Int? {
        guard let vc = self.viewControllers, let index = self.pages.indexOf(vc[0]) else {
            return nil
        }
        
        return index
    }

    init (navigationOrientation: UIPageViewControllerNavigationOrientation = .Horizontal) {
        super.init(transitionStyle: .Scroll, navigationOrientation: navigationOrientation, options: nil)
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPages(pages: [UIViewController]) {
        self.pages = pages
        self.setViewControllers([self.pages[0]], direction: .Forward, animated: false, completion: nil)
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
