//
//  NewsDetailViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/11.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class NewsDetailViewController: ContentsViewController, SlideImageViewDelegate {
    
    private var article: Article!
    
    private var likesCountLabel: InformationLabel!
    private var likeIcon: InteractiveIcon!
    
    private var slideImageView: SlideImageView?

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

        self.hideNavigationBackButtonText()
        self.generateContents()
        self.updateLike()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func generateContents() {
        //
        self.insertSpace(8.0)
        //
        
        // Title View
        let title = self.article.title ?? "タイトル無し"
        let titleView = TitleView(width: self.view.width, title: title, featured: self.article.isTopic)
        self.addContentView(titleView)
        
        //
        self.insertSpace(5.0)
        //
        
        // Meta Label
        let metaLabel = ArticleMetaLabel(width: self.view.width, relatedTitle: self.article.relatedTitle, target: self, action: #selector(NewsDetailViewController.tappedRelatedLink), datetime: self.article.datetime)
        self.addContentView(metaLabel)
        
        // ---
        self.insertSpace(3.0)
        self.insertSeparator(20.0)
        self.insertSpace(15.0)
        // ---
        
        // SlideImageView
        if let medias = self.article.medias where medias.count > 0 {
            self.slideImageView = SlideImageView(height: 200, targetViewController: self, medias: medias)
            self.slideImageView!.delegate = self
            self.addContentView(self.slideImageView!)
            self.insertSpace(15.0)
        }
        
        // Text
        let textLabel = TextLabel(width: self.view.width, text: self.article.text)
        self.addContentView(textLabel)
        
        //
        self.insertSpace(15.0)
        //
        
        // Likes
        let likesCount = "いいね \(self.article.likesCount ?? 0)件"
        self.likesCountLabel = InformationLabel(width: self.view.width, icon: SharedImage.blackHertIcon, text: likesCount)
        self.addContentView(self.likesCountLabel)
        
        // ---
        self.insertSpace(5.0)
        self.insertSeparator(20.0)
        self.insertSpace(10.0)
        // ---
        
        // Like
        var likeImage = SharedImage.largeGrayHertIcon
        if let liked = self.article.liked where liked { likeImage = SharedImage.largeRedHertIcon }
        self.likeIcon = InteractiveIcon(image: likeImage, target: self, action: #selector(NewsDetailViewController.like))
        
        // Share
        let shareIcon = InteractiveIcon(image: SharedImage.shareIcon, target: self, action: #selector(NewsDetailViewController.share))
        
        // Interaction Icon
        let iconBar = HorizontalArrangeView(width: self.view.width, height: 22.0, items: [self.likeIcon, shareIcon])
        self.addContentView(iconBar)
        
        // ---
        self.insertSpace(10.0)
        self.insertSeparator(20.0)
        self.insertSpace(10.0)
        // ---
    }
    
    func tappedRelatedLink() {
        guard let relation = self.article.relation else { return }
        
        switch relation.department {
        case .Event:
            let relatedController = EventsDetailViewController(eventId: relation.id, title: self.article.relatedTitle)
            self.navigationController?.pushViewController(relatedController, animated: true)
        case .Shop:
            let relatedController = ShopsDetailViewController(shopId: relation.id, title: self.article.relatedTitle)
            self.navigationController?.pushViewController(relatedController, animated: true)
        case .Exhibition:
            let relatedController = ExhibitionsDetailViewController(exhibitionId: relation.id, title: self.article.relatedTitle)
            self.navigationController?.pushViewController(relatedController, animated: true)
        }
    }
    
    func like() {
        guard let newsId = self.article.newsId else { return }
        
        if let liked = self.article.liked where liked {
            self.likeIcon.image = SharedImage.largeGrayHertIcon
            HokutosaiApi.DELETE(HokutosaiApi.News.Likes(newsId: newsId)) { response in
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
            HokutosaiApi.POST(HokutosaiApi.News.Likes(newsId: newsId)) { response in
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
            self.article.liked = like.liked
            self.article.likesCount = like.likesCount
            self.likesCountLabel.text = "いいね \(self.article.likesCount ?? 0)件"
            self.newsViewController?.reloadData()
            //self.newsViewController?.updateTimeline()
        }
        
        if let liked = self.article.liked where liked {
            self.likeIcon.image = SharedImage.largeRedHertIcon
        }
        else {
            self.likeIcon.image = SharedImage.grayHertIcon
        }
    }
    
    func updateLike() {
        guard let newsId = self.article.newsId else { return }
        
        HokutosaiApi.GET(HokutosaiApi.News.Details(newsId: newsId)) { response in
            guard response.isSuccess, let data = response.model else {
                return
            }
            
            self.article.liked = data.liked
            self.article.likesCount = data.likesCount
            self.likesCountLabel.text = "いいね \(self.article.likesCount ?? 0)件"
            self.newsViewController?.reloadData()
            
            if let liked = self.article.liked where liked {
                self.likeIcon.image = SharedImage.largeRedHertIcon
            }
            else {
                self.likeIcon.image = SharedImage.grayHertIcon
            }
        }
    }
    
    func share() {
        guard let article = self.article else { return }
        
        var items = [AnyObject]()
        let shareText = "#北斗祭 【\(article.title ?? "タイトル無し")】\n\(article.text ?? "")\n"
        items.append(shareText)
        
        if let imageView = self.slideImageView, let image = imageView.currentPageImage {
            items.append(image)
        }
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func tappedImage(gesture: UIGestureRecognizer, index: Int) {
        guard let medias = self.article.medias else { return }
        let imageViewController = MediaImageViewController(title: self.title, medias: medias, initialPage: index)
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }

}
