//
//  SlidePageViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/29.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class SlidePageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    private var _pages: [UIViewController]!
    
    var pageCount: Int {
        return self._pages.count
    }
    
    var currentPageNumber: Int? {
        guard let vc = self.viewControllers, let index = self._pages.indexOf(vc[0]) else {
            return nil
        }
        
        return index
    }
    
    var viewFrame: CGRect {
        get { return self.view.frame }
        set { self.view.frame = newValue }
    }
    
    var viewOrigin: CGPoint {
        get { return self.view.frame.origin }
        set { self.view.frame.origin = newValue }
    }
    
    var viewSize: CGSize {
        get { return self.view.frame.size }
        set { self.view.frame.size = newValue }
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
    
    var pages: [UIViewController] {
        get { return self._pages }
        set {
            self._pages = newValue
            self.setViewControllers([self._pages[0]], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.currentPageNumber where index > 0 else {
            return nil
        }
        
        return self._pages[index - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.currentPageNumber where index < self.pageCount - 1 else {
            return nil
        }
        
        return self._pages[index + 1]
    }

    func registParentViewController(parentViewController: UIViewController) {
        parentViewController.addChildViewController(self)
        parentViewController.view.addSubview(self.view)
        self.didMoveToParentViewController(parentViewController)
    }

}
