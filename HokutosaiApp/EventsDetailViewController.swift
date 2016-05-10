//
//  EventsDetailViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/04.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit
import Social

class EventsDetailViewController: ContentsViewController {

    private var eventId: UInt!
    private var event: Event?
    
    private var likesCountLabel: InformationLabel!
    private var likeIcon: InteractiveIcon!
    //private var remindIcon: InteractiveIcon!
    
    private weak var timetableViewController: EventsTimetableViewController?
    
    private let topicsBordWidthHeightRatio: CGFloat = 2.0 / 5.0
    
    init (eventId: UInt, title: String?) {
        super.init(title: title)
        self.eventId = eventId
    }
    
    init (event: Event, timetableViewController: EventsTimetableViewController) {
        super.init(title: event.title)
        self.event = event
        self.eventId = event.eventId
        self.timetableViewController = timetableViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let event = self.event {
            self.generateContents(event)
            self.updateLike()
        }
        else {
            self.fetchContents()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchContents() {
        let loadingView = SimpleLoadingView(frame: self.view.frame, backgroundColor: UIColor.whiteColor())
        self.view.addSubview(loadingView)

        HokutosaiApi.GET(HokutosaiApi.Events.Details(eventId: self.eventId)) { response in
            guard response.isSuccess, let data = response.model else {
                self.presentViewController(ErrorAlert.Server.failureGet { action in
                        loadingView.removeFromSuperview()
                        self.navigationController?.popViewControllerAnimated(true)
                    }, animated: true, completion: nil)
                return
            }

            self.event = data
            self.generateContents(data)
            self.updateContentViews()
            loadingView.removeFromSuperview()
        }
    }
    
    func generateContents(event: Event) {
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
        self.insertSpace(5.0)
        //
        
        // TitleView
        let title = event.title ?? "未登録"
        let titleView = TitleView(width: self.view.width, title: title, featured: event.featured)
        self.addContentView(titleView)
        
        //
        self.insertSpace(1.0)
        //
        
        // Status Line
        let status = event.status
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
        let performer = event.performer ?? "未登録"
        let performerLabel = InformationLabel(width: self.view.width, icon: SharedImage.organizerIcon, text: performer)
        self.addContentView(performerLabel)
        
        //
        self.insertSpace(5.0)
        //
        
        // Place
        let place = event.place?.name ?? "未登録"
        let placeLabel = InformationLabel(width: self.view.width, icon: SharedImage.placeIcon, text: place)
        self.addContentView(placeLabel)
        
        //
        self.insertSpace(5.0)
        //
        
        // Datetime
        let datetime = event.holdDateTimeString ?? "未登録"
        let datetimeLabel = InformationLabel(width: self.view.width, icon: SharedImage.clockIcon, text: datetime)
        self.addContentView(datetimeLabel)
        
        //
        self.insertSpace(5.0)
        //
        
        // Likes
        let likesCount = "いいね \(event.likesCount ?? 0)件"
        self.likesCountLabel = InformationLabel(width: self.view.width, icon: SharedImage.blackHertIcon, text: likesCount)
        self.addContentView(self.likesCountLabel)
        
        // ---
        self.insertSpace(10.0)
        self.insertSeparator(20.0)
        self.insertSpace(10.0)
        // ---
        
        // Like
        var likeImage = SharedImage.largeGrayHertIcon
        if let liked = event.liked where liked { likeImage = SharedImage.largeRedHertIcon }
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
        
        // 紹介文見出し
        self.addContentView(InformationLabel(width: self.view.width, icon: SharedImage.introductionIcon, text: "メッセージ"))
        
        //
        self.insertSpace(5.0)
        //
        
        // Detail
        let detailView = TextLabel(width: self.view.width, text: event.detail)
        self.addContentView(detailView)
        
        self.insertSpace(20.0)
        
        self.updateContentViews()
    }
    
    func like() {
        guard let event = self.event, let eventId = event.eventId else { return }
        
        if let liked = event.liked where liked {
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
            self.event?.liked = like.liked
            self.event?.likesCount = like.likesCount
            self.likesCountLabel.text = "いいね \(self.event?.likesCount ?? 0)件"
            self.timetableViewController?.reloadData()
            // もしself.eventがTopicEventであればTimetableのEventは更新されない -> Timetableを更新
            self.timetableViewController?.eventsViewController?.updateTimetables()
        }
        
        if let liked = self.event?.liked where liked {
            self.likeIcon.image = SharedImage.largeRedHertIcon
        }
        else {
            self.likeIcon.image = SharedImage.grayHertIcon
        }
    }
    
    func updateLike() {
        HokutosaiApi.GET(HokutosaiApi.Events.Details(eventId: self.eventId)) { response in
            guard response.isSuccess, let data = response.model else {
                return
            }
            
            // もしself.eventがTopicEventであればTimetableのEventは更新されない。
            // 本来ならばTimetableを更新するべきだがTimetable詳細ビューを開くごとにTimetableを更新するのでは更新が頻繁になるため、ここはでは更新しない。 -> 整合性を犠牲にしている
            self.event?.liked = data.liked
            self.event?.likesCount = data.likesCount
            self.likesCountLabel.text = "いいね \(self.event?.likesCount ?? 0)件"
            self.timetableViewController?.reloadData()
            
            if let liked = self.event?.liked where liked {
                self.likeIcon.image = SharedImage.largeRedHertIcon
            }
            else {
                self.likeIcon.image = SharedImage.grayHertIcon
            }
        }
    }
    
    func share() {
        guard let event = self.event else { return }
        
        let shareText = "#北斗祭 #\(event.title ?? "未登録") "
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    /*
    func remind() {
        
    }
    */
    
}
