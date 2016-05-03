//
//  EventsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit
import PagingMenuController

class EventsViewController: UIViewController, TappableViewControllerDelegate {
    
    private var topics: [TopicEvent]?
    private var schedules: [Schedule]?
    
    private var topicsBordController: FlowingPageViewController!
    private let topicsBordWidthHeightRatio: CGFloat = 2.0 / 5.0
    
    private var timetableViewControllers: [EventsTimetableViewController]?
    private var pagingTimetablesController: PagingMenuController?
    
    private class PagingTimetableOptions: PagingMenuOptions {
        init(defaultPage: Int) {
            super.init()
            self.defaultPage = defaultPage
            self.scrollEnabled = true
            self.backgroundColor = UIColor.trueColor(250, green: 200, blue: 150)
            self.selectedBackgroundColor = UIColor.whiteColor()
            self.textColor = UIColor.grayscale(80)
            self.selectedTextColor = SharedColor.themeColor
            self.font = UIFont.systemFontOfSize(18)
            self.selectedFont = UIFont.boldSystemFontOfSize(18)
            self.menuPosition = .Top
            self.menuHeight = 40
            self.menuItemMargin = 5
            self.animationDuration = 0.3
            self.menuItemMode = .Underline(height: 3, color: SharedColor.themeColor, horizontalPadding: 0, verticalPadding: 0)
            self.menuDisplayMode = .SegmentedControl
        }
    }
    
    private var updatingTopics: Bool = false
    private var updatingEvents: Bool = false
    var updatingContents: Bool { return self.updatingTopics || self.updatingEvents }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "企画"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.generateTopics()
        
        let loadingView = SimpleLoadingView(frame: self.view.frame)
        self.view.addSubview(loadingView)
        self.updateContents() {
            if !self.updatingContents {
                loadingView.removeFromSuperview()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func generateTopics() {
        self.topicsBordController = FlowingPageViewController()
        self.topicsBordController.registParentViewController(self)
        self.topicsBordController.viewOrigin = CGPoint(x: 0.0, y: self.appearOriginY)
        self.topicsBordController.viewSize = CGSize(width: self.view.frame.size.width, height: self.topicsBordWidthHeightRatio * self.view.frame.size.width)
        self.topicsBordController.view.backgroundColor = UIColor.whiteColor()
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: self.topicsBordController.viewSize.height - 0.5, width: self.topicsBordController.viewSize.width, height: UIViewController.pixelWidth))
        bottomLine.backgroundColor = UIColor.grayscale(0, alpha: 80)
        self.topicsBordController.view.addSubview(bottomLine)
    }
    
    private func updateTopics(completion: (() -> Void)? = nil) {
        guard !self.updatingTopics else { return }
        self.updatingTopics = true
        
        HokutosaiApi.GET(HokutosaiApi.Events.Topics()) { response in
            guard response.isSuccess, let data = response.model else {
                self.updatingTopics = false
                completion?()
                return
            }
            
            self.topics = data
            
            var pages = [TopicViewController]()
            for i in 0 ..< data.count {
                let topicViewController = TopicViewController()
                topicViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.topicsBordController.viewSize.width, height: self.topicsBordController.viewSize.height)
                topicViewController.setTopicContentData(i, data: data[i], priorityToImage: true)
                topicViewController.delegate = self
                pages.append(topicViewController)
            }
            
            self.topicsBordController.stopFlowing()
            self.topicsBordController.pages = pages
            self.updatingTopics = false
            completion?()
            self.topicsBordController.startFlowing()
        }
    }
    
    private func updateTimetables(completion: (() -> Void)? = nil) {
        guard !self.updatingEvents else { return }
        self.updatingEvents = true
        
        HokutosaiApi.GET(HokutosaiApi.Events.Schedules()) { response in
            guard response.isSuccess, let data = response.model else {
                self.updatingEvents = false
                completion?()
                return
            }
            
            self.schedules = data
            
            if self.pagingTimetablesController == nil {
                self.generateTimetables(data)
            }
            
            self.updatingEvents = false
            completion?()
        }
    }
    
    private func generateTimetables(schedules: [Schedule]) {
        self.timetableViewControllers = [EventsTimetableViewController(title: "全て")]
        
        let today = NSDate.stringFromDate(NSDate(), format: "yyyy-MM-dd")
        var defaultPage: Int = 0
        for i in 0 ..< schedules.count {
            if schedules[i].dateString == today { defaultPage = i + 1 }
            self.timetableViewControllers!.append(EventsTimetableViewController(title: schedules[i].day))
        }
        
        self.pagingTimetablesController = PagingMenuController(viewControllers: self.timetableViewControllers!, options: PagingTimetableOptions(defaultPage: defaultPage))
        self.pagingTimetablesController!.view.top = self.topicsBordController.view.bottom
        self.addChildViewController(self.pagingTimetablesController!)
        self.view.addSubview(self.pagingTimetablesController!.view)
        self.pagingTimetablesController!.didMoveToParentViewController(self)
    }

    private func updateContents(completion: () -> Void) {
        self.updateTopics(completion)
        self.updateTimetables(completion)
    }
    
    func tappedView(sender: TappableViewController, gesture: UITapGestureRecognizer, tag: Int) {
        print(tag)
    }
    
}
