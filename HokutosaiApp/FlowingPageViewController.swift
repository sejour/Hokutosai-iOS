//
//  FlowingPageViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/29.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class FlowingPageViewController: SlidePageViewController {

    private var timer: NSTimer?
    private var interval: NSTimeInterval
    
    var isFlowing: Bool { return self.timer != nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(interval: NSTimeInterval = 5.0) {
        self.interval = interval
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startFlowing() {
        self.stopFlowing()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.interval, target: self, selector: #selector(FlowingPageViewController.flow), userInfo: nil, repeats: true)
    }
    
    func stopFlowing() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func flow() {
        guard let index = self.currentPageNumber where self.pageCount > 1 else {
            return
        }
        
        let nextIndex = index >= self.pageCount - 1 ? 0 : index + 1
        
        self.setViewControllers([self.pages[nextIndex]], direction: .Forward, animated: true, completion: nil)
    }
    
    override var pages: [UIViewController] {
        get { return super.pages }
        set {
            let flowing = self.isFlowing
            self.stopFlowing()
            super.pages = newValue
            if flowing { self.startFlowing() }
        }
    }
    
    override func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.currentPageNumber where self.pageCount > 1 else {
            return nil
        }
        
        let nextIndex = index <= 0 ? self.pageCount - 1 : index - 1
        
        return self.pages[nextIndex]
    }
    
    override func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.currentPageNumber where self.pageCount > 1 else {
            return nil
        }
        
        let nextIndex = index >= self.pageCount - 1 ? 0 : index + 1
        
        return self.pages[nextIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        self.stopFlowing()
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.startFlowing()
    }

}
