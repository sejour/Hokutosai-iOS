//
//  AssessmentsListViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/13.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class AssessmentsListViewController: UITableViewController {

    private var myAssessment: Assessment?
    private var assessments: [Assessment]?
    
    private let cellIdentifier = "Assessments"
    
    private var updatingContents: Bool = false
    
    private var endpointAssessmentList: HokutosaiApiEndpoint<ObjectResource<AssessmentList>>!
    private var endpointAssessment: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>!
    
    init(myAssessment: Assessment?, endpointAssessmentList: HokutosaiApiEndpoint<ObjectResource<AssessmentList>>, endpointAssessment: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>) {
        super.init(nibName: nil, bundle: NSBundle.mainBundle())
        self.myAssessment = myAssessment
        self.endpointAssessmentList = endpointAssessmentList
        self.endpointAssessment = endpointAssessment
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "評価"
        
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
        let nib = UINib(nibName: "AssessmentTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        
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
            
            self.myAssessment = data.myAssessment
            self.assessments = data.assessments
            self.tableView.reloadData()
            self.updatingContents = false
            completion?()
        }
    }
    
    func onRefresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let assessments = self.assessments else { return 0 }
        return assessments.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AssessmentTableViewCell
        
        cell.changeData(self.assessments![indexPath.row])
        
        return cell
    }
    
}
