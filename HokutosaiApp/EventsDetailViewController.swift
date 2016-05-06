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
    
    // !!! IDだけ指定されてAPIコールでEventを取得してからViewを生成するモードを追加
    
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
        
        //
        self.insertSpace(10.0)
        //
        
        // TitleView
        let title = event.title ?? "未登録"
        let titleView = TitleView(width: self.view.width, title: title, featured: event.featured)
        self.addContentView(titleView)
        
        //
        self.insertSpace(1.0)
        //
        
        // Status Line
        let status = self.event.status
        self.insertSeparator(20.0, color: status.lineColor, width: 5.0)
        
        //
        self.insertSpace(2.0)
        //
        
        // StatusLabel
        let statusLabelProperty = TextLabel.Property()
        statusLabelProperty.color = status.textColor
        statusLabelProperty.font = UIFont.systemFontOfSize(14.0)
        let statusLabel = TextLabel(width: self.view.width, text: status.text, property: statusLabelProperty)
        self.addContentView(statusLabel)
        
        //
        self.insertSpace(5.0)
        //
        
        // Performer
        let performer = self.event.performer ?? "未登録"
        let performerLabel = InformationLabel(width: self.view.width, icon: SharedImage.organizerIcon, text: performer)
        self.addContentView(performerLabel)
        
        //
        self.insertSpace(5.0)
        //
        
        // Place
        let place = self.event.place?.name ?? "未登録"
        let placeLabel = InformationLabel(width: self.view.width, icon: SharedImage.placeIcon, text: place)
        self.addContentView(placeLabel)
        
        //
        self.insertSpace(5.0)
        //
        
        // !!! 状態表示
        
        // Datetime
        let datetime = self.event.holdDateTimeString ?? "未登録"
        let datetimeLabel = InformationLabel(width: self.view.width, icon: SharedImage.clockIcon, text: datetime)
        self.addContentView(datetimeLabel)
        
        //
        self.insertSpace(5.0)
        //
        
        // Likes
        let likesCount = "いいね \(self.event.likesCount ?? 0)件"
        let likesCountLabel = InformationLabel(width: self.view.width, icon: SharedImage.blackHertIcon, text: likesCount)
        self.addContentView(likesCountLabel)
        
        // ---
        self.insertSpace(10.0)
        self.insertSeparator(20.0)
        self.insertSpace(10.0)
        // ---
        
        // !!! InteractiveIconの実装
        
        // Interaction icon
        let likeIcon = UIImageView(image: SharedImage.largeGrayHertIcon)
        let shareIcon = UIImageView(image: SharedImage.shareIcon)
        let remindIcon = UIImageView(image: SharedImage.remindOffIcon)
        let iconBar = HorizontalArrangeView(width: self.view.width, height: 25.0, items: [likeIcon, shareIcon, remindIcon])
        self.addContentView(iconBar)
        
        // ---
        self.insertSpace(10.0)
        self.insertSeparator(20.0)
        self.insertSpace(10.0)
        // ---
        
        // Detail
        let detailView = TextLabel(width: self.view.width, text: self.event.detail)
        self.addContentView(detailView)
        
        // !!! 通知ボタン
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
