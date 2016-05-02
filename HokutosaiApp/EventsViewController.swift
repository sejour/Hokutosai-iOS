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
    
    private var topics: [TopicEvent]!
    private var topicsBordController: FlowingPageViewController!
    private let topicsBordWidthHeightRatio: CGFloat = 2.0 / 5.0
    
    let indexForAll: Int = 0
    let indexForEve: Int = 1
    let indexForFirstDay: Int = 2
    let indexForSecondDay: Int = 3
    let countForTimetable: Int = 4
    let pageTitiles: [String] = ["全て", "前夜祭", "1日目", "2日目"]
    private var eventsTimetableControllers = [EventsTableViewController]()
    private var pagingMenuController: PagingMenuController!
    
    private class EventsPagingMenuOptions: PagingMenuOptions {
        override init() {
            super.init()
            self.defaultPage = 0
            self.scrollEnabled = true
            self.backgroundColor = UIColor.trueColor(250, green: 200, blue: 150)
            self.selectedBackgroundColor = UIColor.whiteColor()
            self.textColor = UIColor.blackColor()
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
        self.generateTableViews()
        
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
    
    private func generateTableViews() {
        for i in 0 ..< self.countForTimetable {
            let timetableController = EventsTableViewController()
            timetableController.title = self.pageTitiles[i]
            self.eventsTimetableControllers.append(timetableController)
        }
        
        self.pagingMenuController = PagingMenuController(viewControllers: self.eventsTimetableControllers, options: EventsPagingMenuOptions())
        self.pagingMenuController.view.top = self.topicsBordController.view.bottom
        self.addChildViewController(pagingMenuController)
        self.view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
    }
    
    private func updateTopics(completion: (() -> Void)? = nil) {
        guard !self.updatingTopics else { return }
        self.updatingTopics = true
        
        HokutosaiApi.GET(HokutosaiApi.Events.Topics()) { response in
            guard response.isSuccess else {
                self.updatingTopics = false
                completion?()
                return
            }
            
            self.topics = response.model
            
            var pages = [TopicViewController]()
            for i in 0 ..< self.topics.count {
                let topicViewController = TopicViewController()
                topicViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.topicsBordController.viewSize.width, height: self.topicsBordController.viewSize.height)
                topicViewController.setTopicContentData(i, data: self.topics[i])
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

    private func updateContents(completion: () -> Void) {
        self.updateTopics(completion)
    }
    
    func tappedView(sender: TappableViewController, gesture: UITapGestureRecognizer, tag: Int) {
        print(tag)
    }
    
}
