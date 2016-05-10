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

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
