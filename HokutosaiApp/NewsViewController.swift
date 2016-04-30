//
//  NewsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit
import SnapKit

class NewsViewController: UIViewController, TappableViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, LikeableTableViewCellDelegate {
    
    private var topics: [TopicNews]!
    private var articles: [Article]!
    
    private var topicsBordController: FlowingPageViewController!
    private var timeline: UITableView!
    
    private let cellIdentifier = "Timeline"
    private let whRatio: CGFloat = 2.0 / 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "特集"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.generateTopics()
        self.generateTimeline()
        
        self.getTopics()
        self.getTimeline()
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
    
    private func getTopics() {
        HokutosaiApi.GET(HokutosaiApi.News.Topics()) { response in
            guard response.isSuccess else {
                self.presentViewController(ErrorAlert.Server.failureGet(), animated: true, completion: nil)
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
            
            self.topicsBordController.pages = pages
            self.topicsBordController.startFlowing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func generateTimeline() {
        self.timeline = UITableView()
        self.view.addSubview(self.timeline)
        self.timeline.snp_makeConstraints { make in
            make.top.equalTo(self.topicsBordController.view.snp_bottom)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        self.timeline.registerClass(NewsTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        self.timeline.rowHeight = NewsTableViewCell.rowHeight
        self.timeline.layoutMargins = UIEdgeInsetsZero
        self.timeline.separatorInset = UIEdgeInsetsZero
        
        self.timeline.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.tabBarHeight, right: 0.0)
        
        self.timeline.dataSource = self
        self.timeline.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NewsViewController.onRefresh(_:)), forControlEvents: .ValueChanged)
        self.timeline.addSubview(refreshControl)
    }
    
    private func getTimeline() {
        HokutosaiApi.GET(HokutosaiApi.News.Timeline()) { response in
            guard response.isSuccess else {
                self.presentViewController(ErrorAlert.Server.failureGet(), animated: true, completion: nil)
                return
            }
            
            self.articles = response.model
            self.timeline.reloadData()
        }
    }
    
    func tappedView(sender: TappableViewController, gesture: UITapGestureRecognizer, tag: Int) {
        print(tag)
    }
    
    func onRefresh(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        refreshControl.endRefreshing()
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

}
