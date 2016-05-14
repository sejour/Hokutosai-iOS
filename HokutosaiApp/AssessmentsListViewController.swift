//
//  AssessmentsListViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/13.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class AssessmentsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MutableContentsController, AssessmentTableViewCellDelegate, AssessmentsWritingViewControllerDelegate {

    private var assessments: [Assessment]?
    
    private var tableView: UITableView!
    
    private let cellIdentifier = "Assessments"
    
    private var updatingContents: Bool = false
    
    private var endpointAssessmentList: HokutosaiApiEndpoint<ObjectResource<AssessmentList>>!
    private var endpointAssessment: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>!
    
    private var contentsType: StandardContentsType
    
    private weak var writingViewControllerDelegate: AssessmentsWritingViewControllerDelegate?
    
    init(contentsType: StandardContentsType, endpointAssessmentList: HokutosaiApiEndpoint<ObjectResource<AssessmentList>>, endpointAssessment: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>, writingViewControllerDelegate: AssessmentsWritingViewControllerDelegate) {
        self.contentsType = contentsType
        super.init(nibName: nil, bundle: NSBundle.mainBundle())
        self.endpointAssessmentList = endpointAssessmentList
        self.endpointAssessment = endpointAssessment
        self.writingViewControllerDelegate = writingViewControllerDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "評価"
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: SharedImage.writeIcon, style: .Plain, target: self, action: #selector(AssessmentsListViewController.writeAssessment))]
        
        self.generateTableView()
        
        let loadingView = SimpleLoadingView(frame: self.view.frame)
        self.view.addSubview(loadingView)
        self.updateContents {
            loadingView.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func generateTableView() {
        self.tableView = UITableView(frame: self.view.frame)
        self.view.addSubview(self.tableView)
        
        let nib = UINib(nibName: "AssessmentTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AssessmentsListViewController.onRefresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    private func updateContents(completion: (() -> Void)?) {
        guard !self.updatingContents else { return }
        self.updatingContents = true
        
        HokutosaiApi.GET(self.endpointAssessmentList) { response in
            guard response.isSuccess, let data = response.model else {
                self.updatingContents = false
                completion?()
                return
            }
            
            guard let assessments = data.assessments where assessments.count > 0 else {
                self.updatingContents = false
                completion?()
                self.presentViewController(UIAlertController.notificationAlertController("評価がありません", message: nil, closeButtonTitle: "OK") { action in
                        self.navigationController?.popViewControllerAnimated(true)
                    }, animated: true, completion: nil
                )
                return
            }
            
            self.assessments = assessments
            self.tableView.reloadData()
            self.updatingContents = false
            completion?()
        }
    }
    
    func updateContents() {
        self.updateContents(nil)
    }
    
    var requiredToUpdateWhenDidChengeTab: Bool { return false }
    var requiredToUpdateWhenWillEnterForeground: Bool { return true }
    
    func onRefresh(sender: UIRefreshControl) {
        self.updateContents {
            sender.endRefreshing()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let assessments = self.assessments else { return 0 }
        return assessments.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AssessmentTableViewCell
        
        cell.changeData(self.assessments![indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func tappedOthersButton(assessmentId: UInt) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        if assessmentId == self.writingViewControllerDelegate?.myAssessment?.assessmentId {
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
        var endpoint: HokutosaiApiEndpoint<ObjectResource<HokutosaiApiStatus>>?
        switch self.contentsType {
        case .Shop:
            endpoint = HokutosaiApi.Shops.AssessmentReport(assessmentId: assessmentId)
        case .Exhibition:
            endpoint = HokutosaiApi.Exhibitions.AssessmentReport(assessmentId: assessmentId)
        }
        
        guard endpoint != nil else { return }
        
        let reportViewController = AssessmentsReportSelectViewController(reportingEndpoint: endpoint!)
        self.presentViewController(UINavigationController(rootViewController: reportViewController), animated: true, completion: nil)
    }
    
    func writeAssessment() {
        let vc = AssessmentsWritingViewController(assessmentEndpoint: self.endpointAssessment, delegate: self)
        self.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    func updateMyAssessment(newMyAssessment: MyAssessment) {
        self.updateContents(nil)
        self.writingViewControllerDelegate?.updateMyAssessment(newMyAssessment)
    }
    
    var myAssessment: Assessment? {
        return self.writingViewControllerDelegate?.myAssessment
    }
    
}
