//
//  ImageViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/11.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class ImageViewController: SlidePageViewController {
    
    private var medias: [Media]!
    private var initialPage: Int = 0
    
    init(medias: [Media], initialPage: Int) {
        super.init()
        self.medias = medias
        self.initialPage = initialPage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        var items = [Item]()
        for media in self.medias {
            guard let url = media.url else { continue }
            let item = Item()
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
    
    class Item: UIViewController {
        
        private var imageView: UIImageView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.backgroundColor = UIColor.blackColor()
            
            self.imageView = UIImageView()
            self.imageView.image = SharedImage.placeholderImage
            self.view.addSubview(self.imageView)
            self.imageView.snp_makeConstraints { make in
                make.left.equalTo(self.view)
                make.top.equalTo(self.view)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.clipsToBounds = true
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func setImageUrl(url: String) {
            guard let imageUrl = NSURL(string: url) else { return }
            self.imageView.af_setImageWithURL(imageUrl, placeholderImage: SharedImage.placeholderImage)
        }
        
    }

}
