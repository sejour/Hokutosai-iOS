//
//  NewsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit
import SnapKit

class NewsViewController: UIViewController, TappableViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
        
        self.timeline.dataSource = self
        self.timeline.delegate = self
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
        //cell.delegate = self
        
        return cell
    }

}
