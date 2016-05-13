//
//  AssessmentsWritingViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/13.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class AssessmentsWritingViewController: ContentsViewController {
    
    var myAssessment: Assessment?
    var assessmentEndpoint: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>!
    
    init (assessmentEndpoint: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>, myAssessment: Assessment?) {
        super.init(title: "評価の投稿")
        self.assessmentEndpoint = assessmentEndpoint
        self.myAssessment = myAssessment
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "キャンセル", style: .Plain, target: self, action: #selector(AssessmentsWritingViewController.cancel))]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "送信", style: .Plain, target: self, action: #selector(AssessmentsWritingViewController.send))]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func send() {
        
    }
    
}