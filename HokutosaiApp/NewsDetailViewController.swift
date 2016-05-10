//
//  NewsDetailViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/11.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class NewsDetailViewController: ContentsViewController {
    
    private var article: Article!
    
    private var likesCountLabel: InformationLabel!
    private var likeIcon: InteractiveIcon!

    private weak var newsViewController: NewsViewController?
    
    init (article: Article, newsViewController: NewsViewController) {
        super.init(title: article.title)
        self.article = article
        self.newsViewController = newsViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.generateContents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func generateContents() {
        //
        self.insertSpace(10.0)
        //
        
        // Title View
        let title = self.article.title ?? "タイトル無し"
        let titleView = TitleView(width: self.view.width, title: title, featured: self.article.isTopic)
        self.addContentView(titleView)
        
        //
        self.insertSpace(8.0)
        //
        
        // Meta Label
        let metaLabel = ArticleMetaLabel(width: self.view.width, relatedTitle: self.article.relatedTitle, target: self, action: #selector(NewsDetailViewController.tappedRelatedLink), datetime: self.article.datetime)
        self.addContentView(metaLabel)
        
        //
        self.insertSpace(1.0)
        self.insertSeparator(20.0)
        self.insertSpace(15.0)
        //
        
        // Text
        let textLabel = TextLabel(width: self.view.width, text: self.article.text)
        self.addContentView(textLabel)
        
        //
        self.insertSpace(20.0)
        //
    }
    
    func tappedRelatedLink() {
        print("tapped")
    }

}
