//
//  NewsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, TappableViewControllerDelegate {
    
    var topics: [TopicNews]!
    
    var topicsBordController: FlowingPageViewController!
    
    let whRatio: CGFloat = 2.0 / 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "特集"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.generateTopics()
    }
    
    private func generateTopics() {
        self.topicsBordController = FlowingPageViewController()
        self.topicsBordController.registParentViewController(self)
        self.topicsBordController.viewOrigin = CGPoint(x: 0.0, y: self.appearOriginY)
        self.topicsBordController.viewSize = CGSize(width: self.view.frame.size.width, height: self.whRatio * self.view.frame.size.width)
        self.topicsBordController.view.backgroundColor = UIColor.whiteColor()
        
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
    
    func tappedView(sender: TappableViewController, gesture: UITapGestureRecognizer, tag: Int) {
        print(tag)
    }

}
