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
    
    init() {
        super.init(nibName: nil, bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        HokutosaiApi.GET(HokutosaiApi.Assessments.ReportCauses()) { response in
            guard response.isSuccess, let data = response.model else {
                self.presentViewController(ErrorAlert.Server.failureGet("報告理由の一覧が取得できなかったため報告できません。") { action in
                    self.navigationController?.popViewControllerAnimated(true)
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
            cell.textLabel?.text = "報告理由を選んでください。"
            cell.selectionStyle = .None
        }
        else {
            cell.textLabel?.text = self.reportCauses![indexPath.row - 1].text
            cell.selectionStyle = .Default
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
