//
//  StandardDetailsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/26.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol StandardTableViewController: MutableContentsController {
    
    func reloadData()

}

class StandardDetailsViewController<ModelType: StandardContentsData, TableViewController: StandardTableViewController>: ContentsViewController {

    private var model: ModelType?
    
    private var likesCountLabel: InformationLabel!
    private var likeIcon: InteractiveIcon!
    
    private weak var tableViewController: TableViewController?
    
    private var endpointDetails: HokutosaiApiEndpoint<ObjectResource<ModelType>>!
    private var endpointLikes: HokutosaiApiEndpoint<ObjectResource<LikeResult>>!
    
    init(endpointDetails: HokutosaiApiEndpoint<ObjectResource<ModelType>>, endpointLikes: HokutosaiApiEndpoint<ObjectResource<LikeResult>>, modelId: UInt, title: String?) {
        super.init(title: title)
        self.endpointDetails = endpointDetails
        self.endpointLikes = endpointLikes
    }
    
    init(endpointDetails: HokutosaiApiEndpoint<ObjectResource<ModelType>>, endpointLikes: HokutosaiApiEndpoint<ObjectResource<LikeResult>>, model: ModelType, tableViewController: TableViewController) {
        super.init(title: model.dataTitle)
        self.endpointDetails = endpointDetails
        self.endpointLikes = endpointLikes
        self.model = model
        self.tableViewController = tableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let model = self.model {
            self.generateContents(model)
            self.updateLike()
        }
        else {
            self.fetchContents()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchContents() {
        let loadingView = SimpleLoadingView(frame: self.view.frame, backgroundColor: UIColor.whiteColor())
        self.view.addSubview(loadingView)
        
        HokutosaiApi.GET(self.endpointDetails) { response in
            guard response.isSuccess, let data = response.model else {
                self.presentViewController(ErrorAlert.Server.failureGet { action in
                    loadingView.removeFromSuperview()
                    self.navigationController?.popViewControllerAnimated(true)
                    }, animated: true, completion: nil)
                return
            }
            
            self.model = data
            self.generateContents(data)
            self.updateContentViews()
            loadingView.removeFromSuperview()
        }
    }
    
    func generateContents(mode: ModelType) {
        
    }
    
    func like() {
        guard let model = self.model else { return }
        
        if let liked = model.dataLiked where liked {
            self.likeIcon.image = SharedImage.largeGrayHertIcon
            HokutosaiApi.DELETE(self.endpointLikes) { response in
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
            HokutosaiApi.POST(self.endpointLikes) { response in
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
            self.model?.dataLiked = like.liked
            self.model?.dataLikesCount = like.likesCount
            self.likesCountLabel.text = "いいね \(self.model?.dataLikesCount ?? 0)件"
            self.tableViewController?.reloadData()
            // もしself.eventがTopicEventであればTimetableのEventは更新されない -> Timetableを更新
            self.tableViewController?.reloadData()
        }
        
        if let liked = self.model?.dataLiked where liked {
            self.likeIcon.image = SharedImage.largeRedHertIcon
        }
        else {
            self.likeIcon.image = SharedImage.grayHertIcon
        }
    }
    
    func updateLike() {
        HokutosaiApi.GET(self.endpointDetails) { response in
            guard response.isSuccess, let data = response.model else {
                return
            }
            
            // もしself.eventがTopicEventであればTimetableのEventは更新されない。
            // 本来ならばTimetableを更新するべきだがTimetable詳細ビューを開くごとにTimetableを更新するのでは更新が頻繁になるため、ここはでは更新しない。 -> 整合性を犠牲にしている
            self.model?.dataLiked = data.dataLiked
            self.model?.dataLikesCount = data.dataLikesCount
            self.likesCountLabel.text = "いいね \(self.model?.dataLikesCount ?? 0)件"
            self.tableViewController?.reloadData()
            
            if let liked = self.model?.dataLiked where liked {
                self.likeIcon.image = SharedImage.largeRedHertIcon
            }
            else {
                self.likeIcon.image = SharedImage.grayHertIcon
            }
        }
    }
    
    func share() {
        
    }

}
