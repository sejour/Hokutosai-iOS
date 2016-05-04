//
//  EventsDetailViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/04.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class EventsDetailViewController: ContentsViewController {

    var event: Event!
    
    private let topicsBordWidthHeightRatio: CGFloat = 2.0 / 5.0
    
    init (event: Event) {
        super.init(title: event.title)
        self.event = event
        self.title = event.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ImageView
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.topicsBordWidthHeightRatio * self.view.width))
        if let imageUrl = event.imageUrl, let url = NSURL(string: imageUrl) {
            imageView.af_setImageWithURL(url, placeholderImage: SharedImage.noImageWide)
        }
        else {
            imageView.image = SharedImage.noImageWide
        }
        self.addContentView(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
