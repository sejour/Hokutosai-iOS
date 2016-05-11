//
//  MediaImageViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/11.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class MediaImageViewController: SlidePageViewController {
    
    private var medias: [Media]!
    private var initialPage: Int = 0
    
    init(title: String?, medias: [Media], initialPage: Int) {
        super.init()
        self.title = title
        self.medias = medias
        self.initialPage = initialPage
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        var items = [ImageViewControllerItem]()
        for media in self.medias {
            guard let url = media.url else { continue }
            let item = ImageViewControllerItem()
            item.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.width, height: self.view.height)
            item.setImageUrl(url)
            items.append(item)
        }
        self.pages = items
        
        // 初期ページの設定
        if self.pages.count > 0 && self.initialPage >= 0 && self.initialPage < self.pages.count {
            self.setViewControllers([self.pages[self.initialPage]], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
