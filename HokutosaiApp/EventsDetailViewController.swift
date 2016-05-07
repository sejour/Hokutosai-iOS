//
//  EventsDetailViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/04.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit
import Social

class EventsDetailViewController: ContentsViewController, MutableContentsController {

    private var event: Event!
    
    private var likesCountLabel: InformationLabel!
    private var likeIcon: InteractiveIcon!
    //private var remindIcon: InteractiveIcon!
    
    private weak var timetableViewController: EventsTimetableViewController?
    
    private let topicsBordWidthHeightRatio: CGFloat = 2.0 / 5.0
    
    init (eventId: UInt?, title: String?, timetableViewController: EventsTimetableViewController) {
        super.init(title: title)
        self.event = Event(eventId: eventId, title: title)
        self.timetableViewController = timetableViewController
    }
    
    init (event: Event, timetableViewController: EventsTimetableViewController) {
        super.init(title: event.title)
        self.event = event
        self.timetableViewController = timetableViewController
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
        
        // Datetime
        let datetime = self.event.holdDateTimeString ?? "未登録"
        let datetimeLabel = InformationLabel(width: self.view.width, icon: SharedImage.clockIcon, text: datetime)
        self.addContentView(datetimeLabel)
        
        //
        self.insertSpace(5.0)
        //
        
        // Likes
        let likesCount = "いいね \(self.event.likesCount ?? 0)件"
        self.likesCountLabel = InformationLabel(width: self.view.width, icon: SharedImage.blackHertIcon, text: likesCount)
        self.addContentView(self.likesCountLabel)
        
        // ---
        self.insertSpace(10.0)
        self.insertSeparator(20.0)
        self.insertSpace(10.0)
        // ---
        
        // Like
        var likeImage = SharedImage.largeGrayHertIcon
        if let liked = self.event.liked where liked { likeImage = SharedImage.largeRedHertIcon }
        self.likeIcon = InteractiveIcon(image: likeImage, target: self, action: #selector(EventsDetailViewController.like))
        
        // Share
        let shareIcon = InteractiveIcon(image: SharedImage.shareIcon, target: self, action: #selector(EventsDetailViewController.share))
        
        // Remind
        //self.remindIcon = InteractiveIcon(image: SharedImage.remindOffIcon, target: self, action: #selector(EventsDetailViewController.remind))
        
        // Interaction Icon
        let iconBar = HorizontalArrangeView(width: self.view.width, height: 22.0, items: [self.likeIcon, shareIcon/*, self.remindIcon*/])
        self.addContentView(iconBar)
        
        // ---
        self.insertSpace(10.0)
        self.insertSeparator(20.0)
        self.insertSpace(10.0)
        // ---
        
        // Detail
        let detailView = TextLabel(width: self.view.width, text: self.event.detail)
        self.addContentView(detailView)
        
        self.insertSpace(20.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func like() {
        guard let eventId = self.event.eventId else { return }
        
        if let liked = self.event.liked where liked {
            self.likeIcon.image = SharedImage.largeGrayHertIcon
            HokutosaiApi.DELETE(HokutosaiApi.Events.Likes(eventId: eventId)) { response in
                guard let result = response.model else {
                    self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                    self.updateLikes(nil)
                    return
                }
                
                self.updateLikes(result)
            }
        }
        else {
            self.likeIcon.image = SharedImage.largeRedHertIcon
            HokutosaiApi.POST(HokutosaiApi.Events.Likes(eventId: eventId)) { response in
                guard let result = response.model else {
                    self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                    self.updateLikes(nil)
                    return
                }
                
                self.updateLikes(result)
            }
        }
    }
    
    func updateLikes(like: LikeResult?) {
        if let like = like {
            self.event.liked = like.liked
            self.event.likesCount = like.likesCount
            self.likesCountLabel.text = "いいね \(self.event.likesCount ?? 0)件"
            self.timetableViewController?.reloadData()
        }
        
        if let liked = self.event.liked where liked {
            self.likeIcon.image = SharedImage.largeRedHertIcon
        }
        else {
            self.likeIcon.image = SharedImage.grayHertIcon
        }
    }
    
    func share() {
        let shareText = "#北斗祭 #\(self.event.title ?? "未登録") "
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    /*
    func remind() {
        
    }
    */
    
    func updateContents() {
        print("update events detail")
    }
    
    var requiredToUpdateWhenDidChengeTab: Bool { return true }
    var requiredToUpdateWhenWillEnterForeground: Bool { return true }
    
}
