//
//  StandardDetailsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/26.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

enum StandardContentsType {
    case Shop
    case Exhibition
}

protocol StandardTableViewController: MutableContentsController {
    
    func reloadData()

}

class StandardDetailsViewController<ModelType: StandardContentsData, TableViewController: StandardTableViewController>: ContentsViewController, AssessmentsWritingViewControllerDelegate, MyAssessmentViewDelegate, StandardInformationViewDelegate {

    private var model: ModelType?
    
    private var likesCountLabel: InformationLabel!
    private var likeIcon: InteractiveIcon!
    private var aggregateView: AssessmentAggregateView?
    private var myAssessmentView: MyAssessmentView!
    private var writeAssessmentIcon: UIBarButtonItem!
    
    var introductionLabelTitle: String!
    
    private weak var tableViewController: TableViewController?
    private weak var assessmentsListViewController: AssessmentsListViewController?
    
    private var endpointModel: HokutosaiApiEndpoint<ObjectResource<ModelType>>!
    private var endpointLikes: HokutosaiApiEndpoint<ObjectResource<LikeResult>>!
    private var endpointAssessmentList: HokutosaiApiEndpoint<ObjectResource<AssessmentList>>!
    private var endpointAssessment: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>!
    
    private var contentsType: StandardContentsType!
    
    init(contentsType: StandardContentsType, endpointModel: HokutosaiApiEndpoint<ObjectResource<ModelType>>, endpointLikes: HokutosaiApiEndpoint<ObjectResource<LikeResult>>, endpointAssessmentList: HokutosaiApiEndpoint<ObjectResource<AssessmentList>>, endpointAssessment: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>, title: String?, introductionLabelTitle: String!) {
        super.init(title: title)
        self.contentsType = contentsType
        self.endpointModel = endpointModel
        self.endpointLikes = endpointLikes
        self.endpointAssessmentList = endpointAssessmentList
        self.endpointAssessment = endpointAssessment
        self.introductionLabelTitle = introductionLabelTitle
    }
    
    init(contentsType: StandardContentsType, endpointModel: HokutosaiApiEndpoint<ObjectResource<ModelType>>, endpointLikes: HokutosaiApiEndpoint<ObjectResource<LikeResult>>, endpointAssessmentList: HokutosaiApiEndpoint<ObjectResource<AssessmentList>>, endpointAssessment: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>, model: ModelType, tableViewController: TableViewController, introductionLabelTitle: String!) {
        super.init(title: model.dataTitle)
        self.contentsType = contentsType
        self.endpointModel = endpointModel
        self.endpointLikes = endpointLikes
        self.endpointAssessmentList = endpointAssessmentList
        self.endpointAssessment = endpointAssessment
        self.model = model
        self.tableViewController = tableViewController
        self.introductionLabelTitle = introductionLabelTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.writeAssessmentIcon = UIBarButtonItem(image: SharedImage.writeIcon, style: .Plain, target: self, action: #selector(StandardDetailsViewController.writeAssessment))
        self.writeAssessmentIcon.enabled = false
        
        let assessmentListViewIcon = UIBarButtonItem(image: UIImage(named: "AssessmentListIcon"), style: .Plain, target: self, action: #selector(StandardDetailsViewController.showAssessmentList))
        
        self.navigationItem.rightBarButtonItems = [writeAssessmentIcon, assessmentListViewIcon]
        
        self.hideNavigationBackButtonText()

        if let model = self.model {
            self.generateContents(model) /* IntroductionViewより上に配置されるViewを作成 (オーバーライドされる) */
            self.layoutIntroductionView(model) /* IntroductionViewを配置 */
            self.updateContentViews() /* 適用 */
            self.updateMutableContents() /* 可変データの更新 */
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
        
        HokutosaiApi.GET(self.endpointModel) { response in
            guard response.isSuccess, let data = response.model else {
                self.presentViewController(ErrorAlert.Server.failureGet { action in
                    loadingView.removeFromSuperview()
                    self.navigationController?.popViewControllerAnimated(true)
                    }, animated: true, completion: nil)
                return
            }
            
            self.model = data
            self.generateContents(data) /* IntroductionViewより上に配置されるViewを作成 (オーバーライドされる) */
            self.layoutIntroductionView(data) /* IntroductionViewを配置 */
            self.updateContentViews() /* 適用 */
            loadingView.removeFromSuperview()
        }
    }
    
    func generateContents(model: ModelType) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(StandardDetailsViewController.onRefresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        //
        self.insertSpace(5.0)
        //
        
        // TitleView
        let title = model.dataTitle ?? "未登録"
        let titleView = TitleView(width: self.view.width, title: title, featured: false)
        self.addContentView(titleView)
        
        //
        self.insertSpace(1.0)
        self.insertSeparator(20.0)
        self.insertSpace(15.0)
        //
        
        // InformationView
        let informationView = StandardInformationView(width: self.view.width, data: model, placeLinkTarget: self, placeLinkAction: #selector(StandardDetailsViewController.showMap))
        informationView.delegate = self
        self.addContentView(informationView)
        
        //
        self.insertSpace(15.0)
        //
        
        // Likes
        let likesCount = "いいね \(model.dataLikesCount ?? 0)件"
        self.likesCountLabel = InformationLabel(width: self.view.width, icon: SharedImage.blackHertIcon, text: likesCount)
        self.addContentView(self.likesCountLabel)
        
        // ---
        self.insertSpace(10.0)
        self.insertSeparator(20.0)
        self.insertSpace(10.0)
        // ---
        
        // Like
        var likeImage = SharedImage.largeGrayHertIcon
        if let liked = model.dataLiked where liked { likeImage = SharedImage.largeRedHertIcon }
        self.likeIcon = InteractiveIcon(image: likeImage, target: self, action: #selector(EventsDetailViewController.like))
        
        // Share
        let shareIcon = InteractiveIcon(image: SharedImage.shareIcon, target: self, action: #selector(EventsDetailViewController.share))
        
        // Interaction Icon
        let iconBar = HorizontalArrangeView(width: self.view.width, height: 22.0, items: [self.likeIcon, shareIcon])
        self.addContentView(iconBar)
        
        // ---
        self.insertSpace(10.0)
        self.insertSeparator(20.0)
        // ---
    }
    
    func layoutIntroductionView(model: ModelType) {
        //
        self.insertSpace(10.0)
        //
        
        // 見出し
        self.addContentView(InformationLabel(width: self.view.width, icon: SharedImage.introductionIcon, text: self.introductionLabelTitle))
        
        //
        self.insertSpace(5.0)
        //
        
        let introductionLabel = TextLabel(width: self.view.width, text: model.dataIntroduction)
        self.addContentView(introductionLabel)
        
        // ---
        self.insertSpace(10.0)
        self.insertSeparator(20.0)
        self.insertSpace(10.0)
        // ---
        
        // 見出し
        self.addContentView(InformationLabel(width: self.view.width, icon: SharedImage.messageIcon, text: "みんなの評価"))
        
        // 集計結果
        if let aggreagete = self.model?.dataAssessmentAggregate {
            //
            self.insertSpace(8.0)
            //
            
            self.aggregateView = AssessmentAggregateView(width: self.view.width, scoreData: aggreagete)
            self.addContentView(self.aggregateView!)
        }
        
        // ---
        self.insertSpace(15.0)
        self.insertSeparator(20.0)
        self.insertSpace(8.0)
        // ---
        
        // 評価を見る
        let showAssessmentListButton = ButtonView(width: self.view.width, text: "評価一覧を見る", target: self, action: #selector(StandardDetailsViewController.showAssessmentList))
        self.addContentView(showAssessmentListButton)
        
        // ---
        self.insertSpace(8.0)
        self.insertSeparator(20.0)
        self.insertSpace(8.0)
        // ---
        
        // 評価 Write/Edit
        self.myAssessmentView = MyAssessmentView(width: self.view.width, delegate: self)
        self.addContentView(self.myAssessmentView)
        
        // ---
        self.insertSpace(8.0)
        self.insertSeparator(20.0)
        self.insertSpace(20.0)
        // ---
    }
    
    func onRefresh(refreshControl: UIRefreshControl) {
        self.updateMutableContents {
            refreshControl.endRefreshing()
        }
    }
    
    func showAssessmentList() {
        let assessmentsListViewController = AssessmentsListViewController(contentsType: self.contentsType, endpointAssessmentList: self.endpointAssessmentList, endpointAssessment: self.endpointAssessment, writingViewControllerDelegate: self)
        self.assessmentsListViewController = assessmentsListViewController
        assessmentsListViewController.writeAssessmentIcon.enabled = self.writeAssessmentIcon.enabled
        self.navigationController?.pushViewController(assessmentsListViewController, animated: true)
    }
    
    func writeAssessment() {
        let vc = AssessmentsWritingViewController(assessmentEndpoint: self.endpointAssessment, delegate: self)
        self.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    var myAssessment: Assessment? {
        return self.model?.dataMyAssessment
    }
    
    func updateMyAssessment(newMyAssessment: MyAssessment) {
        self.model?.dataMyAssessment = newMyAssessment.myAssessment
        
        if let scoreData = newMyAssessment.assessmentAggregate {
            self.model?.dataAssessmentAggregate = scoreData
            self.aggregateView?.updateData(scoreData)
        }
        
        self.myAssessmentView.updateData(newMyAssessment.myAssessment)
        self.updateContentViews()
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
    
    // 可変コンテンツを更新する
    func updateMutableContents(completion: (() -> Void)? = nil) {
        HokutosaiApi.GET(self.endpointModel) { response in
            guard response.isSuccess, let data = response.model else {
                completion?()
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
            
            // 評価結果の更新
            if let scoreData = data.dataAssessmentAggregate {
                self.model?.dataAssessmentAggregate = scoreData
                self.aggregateView?.updateData(scoreData)
            }
            
            // 自分の評価の更新
            self.model?.dataMyAssessment = data.dataMyAssessment
            self.myAssessmentView.updateData(data.dataMyAssessment)
            
            // ビュー更新
            self.updateContentViews()
            self.writeAssessmentIcon.enabled = true
            self.assessmentsListViewController?.writeAssessmentIcon.enabled = true
            
            completion?()
        }
    }
    
    func share() {
        guard let model = self.model else { return }
        
        let shareText = "#北斗祭 #\(model.dataTitle ?? "未登録") "
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func showMap() {
        let vc = ImageViewController(title: "校内マップ", images: [SharedImage.layoutMap])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tappedWrite() {
        self.writeAssessment()
    }
    
    func tappedOthersButton(assessmentId: UInt) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        if assessmentId == self.model?.dataMyAssessment?.assessmentId {
            let editAction = UIAlertAction(title: "評価を編集する", style: .Default) { action in
                self.writeAssessment()
            }
            let deleteAction = UIAlertAction(title: "評価を削除する", style: .Destructive) { action in
                let confirmAlert = UIAlertController(title: "評価を削除", message: "本当に評価を削除してもよろしいですか？", preferredStyle: .Alert)
                confirmAlert.addAction(UIAlertAction(title: "削除", style: .Default) { action in
                    self.deleteMyAssessment()
                    })
                confirmAlert.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
                self.presentViewController(confirmAlert, animated: true, completion: nil)
            }
            
            alertController.addAction(editAction)
            alertController.addAction(deleteAction)
        }
        else {
            let reportAction = UIAlertAction(title: "このコメントを報告する", style: .Default) { action in
                self.report(assessmentId)
            }
            alertController.addAction(reportAction)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func deleteMyAssessment() {
        HokutosaiApi.DELETE(self.endpointAssessment) { response in
            guard response.isSuccess, let data = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                return
            }
            
            self.updateMyAssessment(data)
        }
    }
    
    func report(assessmentId: UInt) {
        guard let contentsType = self.contentsType else { return }
        
        var endpoint: HokutosaiApiEndpoint<ObjectResource<HokutosaiApiStatus>>?
        switch contentsType {
        case .Shop:
            endpoint = HokutosaiApi.Shops.AssessmentReport(assessmentId: assessmentId)
        case .Exhibition:
            endpoint = HokutosaiApi.Exhibitions.AssessmentReport(assessmentId: assessmentId)
        }
        
        guard endpoint != nil else { return }
        
        let reportViewController = AssessmentsReportSelectViewController(reportingEndpoint: endpoint!)
        self.presentViewController(UINavigationController(rootViewController: reportViewController), animated: true, completion: nil)
    }
    
    func tappedImage(image: UIImage?) {
        let imageVC = ImageViewController(title: self.title, images: [image])
        self.navigationController?.pushViewController(imageVC, animated: true)
    }

}
