//
//  NewsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, TappableViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, LikeableTableViewCellDelegate, TabBarIntaractiveController, MutableContentsController {
    
    private var topics: [TopicNews]?
    private var articles: [Article]?
    
    private var topicsBordController: FlowingPageViewController!
    private var timeline: UITableView!
    
    private let cellIdentifier = "Timeline"
    private let whRatio: CGFloat = 2.0 / 5.0
    
    private var updatingTopics: Bool = false
    private var updatingTimeline: Bool = false
    var updatingContents: Bool { return self.updatingTopics || self.updatingTimeline }
    
    private let onceGetArticleCount: UInt = 25
    private var articlesHitBottom: Bool = false
    private var loadingCellManager: LoadingCellManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "お知らせ"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.generateTopics()
        self.generateTimeline()
        
        self.loadingCellManager = LoadingCellManager(cellWidth: self.timeline.width, backgroundColor: UIColor.whiteColor(), textColor: UIColor.blueColor(), textForReadyReload: "もう一度読み込む")
        
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
        
        if self.articles != nil {
            while (UInt(self.articles!.count) > self.onceGetArticleCount) {
                self.articles!.removeLast()
            }
            self.articlesHitBottom = false
            self.timeline?.reloadData()
            self.timeline?.setContentOffset(CGPointZero, animated: false)
        }
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
        
        self.timeline.setContentAndScrollInsets(UIEdgeInsets(top: 0.0, left: 0.0, bottom: MainTabViewController.mainController.tabBar.height, right: 0.0))
        
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
                topicViewController.setTopicContentData(i, data: data[i])
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
        self.updateTimeline(nil, completion: completion)
    }
    
    private func updateTimeline(lastId: UInt?, completion: (() -> Void)? = nil) {
        guard !self.updatingTimeline else { return }
        self.updatingTimeline = true
        
        var params: [String: UInt] = ["count": self.onceGetArticleCount]
        if let lastId = lastId {
            params["last_id"] = lastId - 1
        }
        
        HokutosaiApi.GET(HokutosaiApi.News.Timeline(), parameters: params) { response in
            guard response.isSuccess, let data = response.model else {
                if lastId != nil {
                    self.loadingCellManager.status = .ReadyReload
                }
                self.updatingTimeline = false
                completion?()
                return
            }
            
            self.loadingCellManager.status = .Loading
            self.articlesHitBottom = UInt(data.count) < self.onceGetArticleCount
            
            if let articles = self.articles where lastId != nil {
                self.articles = articles + data
            }
            else {
                self.articles = data
            }
            
            self.timeline.reloadData()
            self.updatingTimeline = false
            completion?()
        }
    }
    
    private func updateContents(completion: () -> Void) {
        self.updateTopics(completion)
        self.updateTimeline(completion)
    }
    
    func updateContents() {
        guard self.topicsBordOpened && self.topicsBordController != nil && self.timeline != nil else { return }
        self.updateTopics()
        self.updateTimeline() {
            self.timeline.setContentOffset(CGPointZero, animated: false)
        }
    }
    
    var requiredToUpdateWhenDidChengeTab: Bool { return true }
    var requiredToUpdateWhenWillEnterForeground: Bool { return true }
    
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
    
    func tabBarIconTapped() {
        self.timeline?.setContentOffset(CGPointZero, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let articles = self.articles else { return }
        guard indexPath.row < articles.count else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.loadingCellManager.status = .Loading
            self.updateTimeline(articles.last?.newsId)
            return
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articles = self.articles else {
            return 0
        }
        
        // 底に着いていればLoadingCellを表示しない
        return articles.count + (self.articlesHitBottom ? 0 : 1)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let articles = self.articles else { return NewsTableViewCell.rowHeight }
        guard indexPath.row < articles.count else {
            return LoadingCellManager.cellRowHeight
        }
        
        return NewsTableViewCell.rowHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard indexPath.row < self.articles!.count else {
            self.updateTimeline(self.articles!.last?.newsId)
            return self.loadingCellManager.cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsTableViewCell
        
        cell.changeData(indexPath.row, article: self.articles![indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func like(index: Int, cell: LikeableTableViewCell) {
        guard self.articles != nil else { return }
        
        let newsId = self.articles![index].newsId!
        HokutosaiApi.POST(HokutosaiApi.News.Likes(newsId: newsId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(newsId)
                return
            }
            
            self.articles![index].liked = result.liked
            self.articles![index].likesCount = result.likesCount
            cell.updateLikes(newsId)
        }
    }
    
    func dislike(index: Int, cell: LikeableTableViewCell) {
        guard self.articles != nil else { return }
        
        let newsId = self.articles![index].newsId!
        HokutosaiApi.DELETE(HokutosaiApi.News.Likes(newsId: newsId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(newsId)
                return
            }
            
            self.articles![index].liked = result.liked
            self.articles![index].likesCount = result.likesCount
            cell.updateLikes(newsId)
        }
    }
    
    // scrolling ------------------------------------------------------------------------------------
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        self.openCloseTopicsBord(offsetY)
    }
    
    // ----------------------------------------------------------------------------------------------
    
    // Open/Close Topics bord -----------------------------------------------------------------------
    
    private let durationForOpenClose: NSTimeInterval = 0.3
    private let advancedDistanceThresholdForClosing: CGFloat = 50.0
    private let contentLimitForClosing = 10
    private let speedThresholdForOpening: CGFloat = -30.0
    private let offsetThresholdForOpening: CGFloat = 100.0
    
    private var scrollStartOffsetY: CGFloat = 0.0
    private var scrollPreviousOffsetY: CGFloat = 0.0
    private var topicsBordOpened: Bool = true
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.scrollStartOffsetY = scrollView.contentOffset.y
    }
    
    private func openCloseTopicsBord(offsetY: CGFloat) {
        guard let articles = self.articles else { return }
        let advancedDistance = offsetY - self.scrollStartOffsetY
        
        if self.topicsBordOpened && advancedDistance >= self.advancedDistanceThresholdForClosing && articles.count >= self.contentLimitForClosing {
            self.topicsBordOpened = false
            self.timeline.setContentAndScrollInsets(UIEdgeInsets(top: self.appearOriginY, left: 0.0, bottom: MainTabViewController.mainController.tabBar.height, right: 0.0))
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
                        self.timeline.setContentAndScrollInsets(UIEdgeInsets(top: 0.0, left: 0.0, bottom: MainTabViewController.mainController.tabBar.height, right: 0.0))
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
