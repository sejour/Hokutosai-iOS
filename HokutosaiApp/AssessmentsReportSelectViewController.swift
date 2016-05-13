//
//  AssessmentsReportSelectViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/13.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class AssessmentsReportSelectViewController: UITableViewController {
    
    private var reportCauses: [AssessmentReportCause]?

    private let cellIdentifier = "AssessmentReport"
    
    private var reportingEndpoint: HokutosaiApiEndpoint<ObjectResource<HokutosaiApiStatus>>!
    
    init(reportingEndpoint: HokutosaiApiEndpoint<ObjectResource<HokutosaiApiStatus>>) {
        super.init(nibName: nil, bundle: NSBundle.mainBundle())
        self.reportingEndpoint = reportingEndpoint
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "報告する"
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "キャンセル", style: .Plain, target: self, action: #selector(AssessmentsReportSelectViewController.cancelReporting))]
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        HokutosaiApi.GET(HokutosaiApi.Assessments.ReportCauses()) { response in
            guard response.isSuccess, let data = response.model else {
                self.presentViewController(ErrorAlert.Server.failureGet("報告理由の一覧が取得できなかったため報告できません。") { action in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    }, animated: true, completion: nil)
                return
            }
            
            self.reportCauses = data
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelReporting() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reportCauses = self.reportCauses else { return 0 }
        return reportCauses.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath)

        if indexPath.row == 0 {
            cell.textLabel?.text = "報告理由を選んでください"
            cell.textLabel?.font = UIFont.systemFontOfSize(17.0)
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.selectionStyle = .None
        }
        else {
            cell.textLabel?.text = self.reportCauses![indexPath.row - 1].text
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(17.0)
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.selectionStyle = .Default
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 0 {
            let reportCause = self.reportCauses![indexPath.row - 1]
            if let causeId = reportCause.causeId {
                self.confirmReporting(causeId, text: reportCause.text ?? "")
            }
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func confirmReporting(causeId: String, text: String) {
        let confirmAlert = UIAlertController(title: "報告してよろしいですか？", message: "報告理由: \(text)", preferredStyle: .Alert)
        confirmAlert.addAction(UIAlertAction(title: "OK", style: .Default) { action in
            self.report(causeId)
        })
        confirmAlert.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
        self.presentViewController(confirmAlert, animated: true, completion: nil)
    }
    
    private func report(causeId: String) {
        HokutosaiApi.POST(self.reportingEndpoint, parameters: ["cause": causeId]) { response in
            guard response.isSuccess, let data = response.model where data.statusCode < 400 else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest("報告できませんでした", handler: { action in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }), animated: true, completion: nil)
                return
            }
            
            self.presentViewController(UIAlertController.notificationAlertController("報告しました", message: nil, closeButtonTitle: "OK", handler: { action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }), animated: true, completion: nil)
        }
    }

}
