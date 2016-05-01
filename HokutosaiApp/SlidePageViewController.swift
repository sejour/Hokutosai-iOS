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
        guard let vc = self.viewControllers, let firstView = vc.first, let index = self._pages.indexOf(firstView) else {
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
        
        self._pages = self.dummyPages()
        self.setViewControllers([self._pages.first!], direction: .Forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var pages: [UIViewController] {
        get { return self._pages }
        set {
            self._pages = newValue.count > 0 ? newValue : self.dummyPages()
            self.setViewControllers([self._pages.first!], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.currentPageNumber where index > 0 && self.pageCount > 1 else {
            return nil
        }
        
        return self._pages[index - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.currentPageNumber where (index < self.pageCount - 1) && self.pageCount > 1 else {
            return nil
        }
        
        return self._pages[index + 1]
    }

    func registParentViewController(parentViewController: UIViewController) {
        parentViewController.addChildViewController(self)
        parentViewController.view.addSubview(self.view)
        self.didMoveToParentViewController(parentViewController)
    }
    
    private func dummyPages() -> [UIViewController] {
        let vc = UIViewController()
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.width, height: self.view.height)
        vc.view.backgroundColor = UIColor.whiteColor()
        return [vc]
    }

}
