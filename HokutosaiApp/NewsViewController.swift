//
//  NewsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, TappableViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, LikeableTableViewCellDelegate {
    
    private var topics: [TopicNews]!
    private var articles: [Article]!
    
    private var topicsBordController: FlowingPageViewController!
    private var timeline: UITableView!
    
    private let cellIdentifier = "Timeline"
    private let whRatio: CGFloat = 2.0 / 5.0
    
    private var updatingTopics: Bool = false
    private var updatingTimeline: Bool = false
    var updatingContents: Bool { return self.updatingTopics || self.updatingTimeline }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "特集"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.generateTopics()
        self.generateTimeline()
        
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
        self.topicsBordController.viewSize = CGSize(width: self.view.frame.size.width, height: self.whRatio * self.view.frame.size.width)
        self.topicsBordController.view.backgroundColor = UIColor.whiteColor()
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: self.topicsBordController.viewSize.height - 0.5, width: self.topicsBordController.viewSize.width, height: UIViewController.pixelWidth))
        bottomLine.backgroundColor = UIColor.grayscale(0, alpha: 80)
        self.topicsBordController.view.addSubview(bottomLine)
    }
    
    private func generateTimeline() {
        self.timeline = UITableView(frame: self.timeLineFrame)
        self.view.addSubview(self.timeline)
        
        self.timeline.registerClass(NewsTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        self.timeline.rowHeight = NewsTableViewCell.rowHeight
        self.timeline.layoutMargins = UIEdgeInsetsZero
        self.timeline.separatorInset = UIEdgeInsetsZero
        
        self.timeline.setContentAndScrollInsets(UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.tabBarHeight, right: 0.0))
        
        self.timeline.dataSource = self
        self.timeline.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NewsViewController.onRefresh(_:)), forControlEvents: .ValueChanged)
        self.timeline.addSubview(refreshControl)
    }
    
    private func updateTopics(completion: (() -> Void)? = nil) {
        guard !self.updatingTopics else { return }
        self.updatingTopics = true
        
        HokutosaiApi.GET(HokutosaiApi.News.Topics()) { response in
            guard response.isSuccess else {
                self.presentViewController(ErrorAlert.Server.failureGet(), animated: true, completion: nil)
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
    
    private func updateTimeline(completion: (() -> Void)? = nil) {
        guard !self.updatingTimeline else { return }
        self.updatingTimeline = true
        
        HokutosaiApi.GET(HokutosaiApi.News.Timeline()) { response in
            guard response.isSuccess else {
                self.presentViewController(ErrorAlert.Server.failureGet(), animated: true, completion: nil)
                self.updatingTimeline = false
                completion?()
                return
            }
            
            self.articles = response.model
            self.timeline.reloadData()
            self.updatingTimeline = false
            completion?()
        }
    }
    
    func updateContents(completion: (() -> Void)? = nil) {
        self.updateTopics(completion)
        self.updateTimeline(completion)
    }
    
    func tappedView(sender: TappableViewController, gesture: UITapGestureRecognizer, tag: Int) {
        print(tag)
    }
    
    func onRefresh(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        
        self.updateContents() {
            if !self.updatingContents {
                refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.timeline.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articles = self.articles else {
            return 0
        }
        
        return articles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return NewsTableViewCell.rowHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsTableViewCell
        
        cell.changeData(indexPath.row, article: self.articles[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func like(index: Int, cell: LikeableTableViewCell) {
        let newsId = self.articles[index].newsId!
        HokutosaiApi.POST(HokutosaiApi.News.Likes(newsId: newsId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(newsId)
                return
            }
            
            self.articles[index].liked = result.liked
            self.articles[index].likesCount = result.likesCount
            cell.updateLikes(newsId)
        }
    }
    
    func dislike(index: Int, cell: LikeableTableViewCell) {
        let newsId = self.articles[index].newsId!
        HokutosaiApi.DELETE(HokutosaiApi.News.Likes(newsId: newsId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(newsId)
                return
            }
            
            self.articles[index].liked = result.liked
            self.articles[index].likesCount = result.likesCount
            cell.updateLikes(newsId)
        }
    }
    
    // Open/Close Topics bord -----------------------------------------------------------------------
    
    private let durationForOpenClose: NSTimeInterval = 0.3
    private let advancedDistanceThresholdForClosing: CGFloat = 50.0
    private let speedThresholdForOpening: CGFloat = -30.0
    private let offsetThresholdForOpening: CGFloat = 100.0
    
    private var scrollStartOffsetY: CGFloat = 0.0
    private var scrollPreviousOffsetY: CGFloat = 0.0
    private var topicsBordOpened: Bool = true
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.scrollStartOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let advancedDistance = offsetY - self.scrollStartOffsetY
        
        if self.topicsBordOpened && advancedDistance >= self.advancedDistanceThresholdForClosing {
            self.topicsBordOpened = false
            self.timeline.setContentAndScrollInsets(UIEdgeInsets(top: self.appearOriginY, left: 0.0, bottom: self.tabBarHeight, right: 0.0))
            UIView.animateWithDuration(self.durationForOpenClose) {
                self.topicsBordController.viewOrigin.y = -self.topicsBordController.viewSize.height
                self.timeline.frame = self.timeLineFrame
            }
        }
        else if !self.topicsBordOpened {
            let speed = offsetY - self.scrollPreviousOffsetY
            if speed <= self.speedThresholdForOpening || (offsetY < self.offsetThresholdForOpening && advancedDistance < 0) {
                self.topicsBordOpened = true
                UIView.animateWithDuration(self.durationForOpenClose, animations: {
                    self.topicsBordController.viewOrigin.y = self.appearOriginY
                    }, completion: { _ in
                        self.timeline.setContentAndScrollInsets(UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.tabBarHeight, right: 0.0))
                        UIView.animateWithDuration(self.durationForOpenClose) {
                            self.timeline.frame = self.timeLineFrame
                    }
                })
            }
        }
        
        self.scrollPreviousOffsetY = offsetY
    }
    
    // ----------------------------------------------------------------------------------------------
    
    private var timeLineFrame: CGRect {
        let originY = self.topicsBordController.view.bottom
        return CGRect(x: 0.0, y: originY, width: self.view.width, height: self.view.bottom - originY)
    }

}
